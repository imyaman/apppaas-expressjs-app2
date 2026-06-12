var express = require('express');
var net = require('net');
var dns = require('dns').promises;
var os = require('os');
var path = require('path');
var router = express.Router();

var pkg = require(path.join(__dirname, '..', 'package.json'));

/* Try a TCP connect to host:port and, on success, read the MySQL server
 * greeting to confirm it is a real MariaDB/MySQL daemon (not just an open
 * port). Returns one of:
 *   { ok: true,  protocolVersion, serverVersion, greetingBytes, elapsedMs }
 *   { ok: false, error, elapsedMs }
 */
function probe(host, port, timeoutMs) {
  return new Promise(function (resolve) {
    var started = Date.now();
    var sock = new net.Socket();
    var buf = Buffer.alloc(0);
    var done = false;

    function finish(result) {
      if (done) return;
      done = true;
      try { sock.destroy(); } catch (_) {}
      resolve(Object.assign({
        host: host,
        port: port,
        elapsedMs: Date.now() - started
      }, result));
    }

    sock.setTimeout(timeoutMs);
    sock.once('timeout', function () {
      finish({ ok: false, error: 'timeout after ' + timeoutMs + 'ms' });
    });
    sock.once('error', function (err) {
      finish({ ok: false, error: err.code || err.message });
    });
    sock.once('end', function () {
      finish({ ok: false, error: 'server closed before full greeting' });
    });
    sock.once('close', function () {
      finish({ ok: false, error: 'socket closed before full greeting' });
    });
    sock.connect(port, host, function () {
      sock.on('data', function (chunk) {
        buf = Buffer.concat([buf, chunk]);
        if (buf.length > 65536) {
          finish({ ok: false, error: 'greeting buffer exceeded 65536 bytes (bail)' });
          return;
        }
        if (buf.length < 4) return;
        var pktLen = buf[0] | (buf[1] << 8) | (buf[2] << 16);
        if (pktLen > 65536) {
          finish({ ok: false, error: 'greeting length ' + pktLen + ' > 65536 (bail)' });
          return;
        }
        if (buf.length < 4 + pktLen) return;
        var protoVer = buf[4];
        if (protoVer !== 10) {
          finish({ ok: false, error: 'not a MySQL/MariaDB server (protocol version ' + protoVer + ')' });
          return;
        }
        var nullIdx = buf.indexOf(0, 5);
        var serverVersion = nullIdx > 4 ? buf.slice(5, nullIdx).toString('utf8') : null;
        finish({
          ok: true,
          protocolVersion: protoVer,
          serverVersion: serverVersion,
          greetingBytes: 4 + pktLen
        });
      });
    });
  });
}

function dnsResolve(name) {
  /* dns.lookup's `timeout` option is best-effort: it fires a JS-side timer
   * but the underlying libc getaddrinfo may keep running. Race a hard
   * 1500 ms timeout so the request is guaranteed fast on any platform. */
  var lookup = dns.lookup(name, { all: true, timeout: 1500 })
    .then(function (addrs) { return addrs.map(function (a) { return a.address; }); })
    .catch(function (err) { return { error: err.code || err.message }; });
  var hardTimeout = new Promise(function (resolve) {
    setTimeout(function () { resolve({ error: 'dns-timeout' }); }, 1500);
  });
  return Promise.race([lookup, hardTimeout]);
}

/* GET /dbcheck — probe a fixed list of candidate MariaDB endpoints and
 * return DNS + TCP/greeting result for each as JSON. */
router.get('/', async function (req, res) {
  var targets = [
    { name: 's3 (short hostname from wiki)', host: 's3', port: 3306 },
    { name: 's3 (public IP from wiki)',      host: '141.148.137.172', port: 3306 },
    { name: 'mariadb (compose service)',     host: 'mariadb', port: 3306 },
    { name: 'localhost',                     host: '127.0.0.1', port: 3306 },
    { name: 'apppaas-db (guess)',            host: 'apppaas-db', port: 3306 }
  ];
  var requestedTimeout = req.query.timeout != null ? String(req.query.timeout) : null;
  var timeoutMs = Math.min(Math.max(parseInt(req.query.timeout, 10) || 3000, 100), 10000);

  var results = await Promise.all(targets.map(async function (t) {
    var dnsInfo = null;
    if (!net.isIP(t.host)) {
      dnsInfo = await dnsResolve(t.host);
    }
    var probeResult = await probe(t.host, t.port, timeoutMs);
    return {
      name: t.name,
      host: t.host,
      port: t.port,
      dns: dnsInfo,
      probe: probeResult
    };
  }));

  res.json({
    appName: pkg.name,
    version: pkg.version,
    pod: {
      hostname: os.hostname(),
      networkInterfaces: Object.keys(os.networkInterfaces()).reduce(function (acc, k) {
        acc[k] = os.networkInterfaces()[k].map(function (i) {
          return { address: i.address, family: i.family, internal: i.internal };
        });
        return acc;
      }, {})
    },
    probedAt: new Date().toISOString(),
    requestedTimeout: requestedTimeout,
    timeoutMs: timeoutMs,
    targets: results
  });
});

module.exports = router;
