var os = require('os');
var path = require('path');
var fs = require('fs');
var http = require('http');
var https = require('https');
var { execFileSync } = require('child_process');

// Public IP discovery: hit ifconfig.me and friends via HTTPS.
var IPV4_SERVICES = [
  { name: 'ifconfig.me', host: 'ifconfig.me', path: '/ip' },
  { name: 'api.ipify.org', host: 'api.ipify.org', path: '/' },
  { name: 'icanhazip.com', host: 'icanhazip.com', path: '/' }
];

function fetchPublicIpFrom(service, timeoutMs) {
  return new Promise(function (resolve) {
    var done = false;
    var req = https.request({
      host: service.host,
      path: service.path,
      method: 'GET',
      timeout: timeoutMs,
      headers: { 'User-Agent': 'apppaas-sysinfo/1.0' }
    }, function (res) {
      var chunks = [];
      res.on('data', function (c) { chunks.push(c); });
      res.on('end', function () {
        if (done) return;
        done = true;
        var body = Buffer.concat(chunks).toString('utf8').trim();
        if (res.statusCode >= 200 && res.statusCode < 300 && /^\d+\.\d+\.\d+\.\d+$/.test(body)) {
          resolve({ ok: true, service: service.name, ip: body, status: res.statusCode });
        } else {
          resolve({ ok: false, service: service.name, status: res.statusCode, body: body });
        }
      });
    });
    req.on('timeout', function () {
      if (done) return;
      done = true;
      req.destroy(new Error('timeout'));
      resolve({ ok: false, service: service.name, error: 'timeout' });
    });
    req.on('error', function (e) {
      if (done) return;
      done = true;
      resolve({ ok: false, service: service.name, error: e.message });
    });
    req.end();
  });
}

function publicIp(timeoutMs) {
  timeoutMs = timeoutMs || 3000;
  return Promise.all(IPV4_SERVICES.map(function (s) { return fetchPublicIpFrom(s, timeoutMs); }))
    .then(function (results) {
      var winner = null;
      for (var i = 0; i < results.length; i++) {
        if (results[i].ok) { winner = results[i]; break; }
      }
      return {
        ip: winner ? winner.ip : null,
        service: winner ? winner.service : null,
        checkedAt: new Date().toISOString(),
        attempts: results
      };
    });
}

function bytes(n) {
  if (n == null) return 'n/a';
  var units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
  var i = 0;
  var v = Number(n);
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  return v.toFixed(2) + ' ' + units[i];
}

function storage() {
  // Use `df -kP` for portable POSIX output. Parse the first non-header line.
  try {
    var out = execFileSync('df', ['-kP', '/'], { encoding: 'utf8', timeout: 2000 });
    var lines = out.trim().split('\n').filter(Boolean);
    if (lines.length < 2) return null;
    var cols = lines[1].split(/\s+/);
    return {
      filesystem: cols[0],
      size: bytes(Number(cols[1]) * 1024),
      used: bytes(Number(cols[2]) * 1024),
      available: bytes(Number(cols[3]) * 1024),
      capacity: cols[4],
      mount: cols[5]
    };
  } catch (e) {
    return { error: e.message };
  }
}

function mem() {
  var total = os.totalmem();
  var free = os.freemem();
  return {
    total: bytes(total),
    free: bytes(free),
    used: bytes(total - free),
    usedPct: ((1 - free / total) * 100).toFixed(1) + '%'
  };
}

function cpu() {
  var cpus = os.cpus() || [];
  var model = cpus[0] ? cpus[0].model : 'unknown';
  var speed = cpus[0] ? cpus[0].speed : 0;
  return {
    model: model,
    speedMHz: speed,
    count: cpus.length,
    loadavg: os.loadavg().map(function (n) { return n.toFixed(2); })
  };
}

function network() {
  var ifaces = os.networkInterfaces();
  var list = [];
  Object.keys(ifaces).forEach(function (name) {
    ifaces[name].forEach(function (i) {
      list.push({
        name: name,
        address: i.address,
        family: i.family,
        internal: i.internal,
        mac: i.mac
      });
    });
  });
  return list;
}

function user() {
  try { return os.userInfo(); } catch (e) { return { error: e.message }; }
}

function proc() {
  var r = {
    pid: process.pid,
    ppid: process.ppid,
    title: process.title,
    argv: process.argv,
    execPath: process.execPath,
    cwd: process.cwd(),
    uid: process.getuid ? process.getuid() : null,
    gid: process.getgid ? process.getgid() : null,
    nodeVersions: process.versions,
    platform: process.platform,
    arch: process.arch,
    uptimeSec: Math.round(process.uptime()),
    resourceUsage: process.resourceUsage ? process.resourceUsage() : null
  };
  return r;
}

function env() {
  // Return everything, but mark a curated list of "common" keys for the top section.
  var all = process.env || {};
  var keys = Object.keys(all);
  var commonKeys = [
    'NODE_ENV', 'PORT', 'HOST', 'HOSTNAME', 'USER', 'USERNAME',
    'HOME', 'PWD', 'SHELL', 'PATH', 'LANG', 'LC_ALL', 'TZ',
    'KUBERNETES_SERVICE_HOST', 'KUBERNETES_PORT'
  ];
  var common = {};
  commonKeys.forEach(function (k) {
    if (all[k] != null) common[k] = all[k];
  });
  return { count: keys.length, common: common, all: all };
}

function osInfo() {
  return {
    hostname: os.hostname(),
    type: os.type(),
    platform: os.platform(),
    arch: os.arch(),
    release: os.release(),
    version: os.version && os.version(),
    uptimeSec: Math.round(os.uptime()),
    endianness: os.endianness(),
    tmpdir: os.tmpdir(),
    homedir: os.homedir(),
    cpus: cpu(),
    memory: mem(),
    storage: storage(),
    user: user(),
    network: network()
  };
}

module.exports = {
  collect: function () {
    return {
      generatedAt: new Date().toISOString(),
      os: osInfo(),
      process: proc(),
      env: env(),
      publicIp: null  // populated by collectWithPublicIp() to keep this sync
    };
  },
  collectWithPublicIp: function () {
    var data = {
      generatedAt: new Date().toISOString(),
      os: osInfo(),
      process: proc(),
      env: env(),
      publicIp: null
    };
    return publicIp().then(function (ip) {
      data.publicIp = ip;
      return data;
    });
  }
};
