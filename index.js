// seaf-server relay (Host-S side of the SeaTable split).
//
//   [app tier] seahub -> /var/run/seafile.sock -> (unix->ws client)
//        == WebSocket over HTTP :3000 ==>
//   [this app] ws -> seaf-server unix socket   (+ spawns native seaf-server)
//
// Runs via `npm start`; listens on :3000 (HTTP health + WS relay at /seaf).
import express from 'express';
import http from 'node:http';
import net from 'node:net';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { execFile, spawn } from 'node:child_process';
import httpProxy from 'http-proxy';
import config from './lib/config.js';
import { startSeafServer, waitForSocket, stopSeafServer, tailLog } from './lib/seafServer.js';
import { attachRelay } from './lib/relay.js';
import { attachFileProxy } from './lib/fileProxy.js';
import { initSeaf } from './lib/initSeaf.js';
import { status } from './lib/status.js';

const app = express();
let relay;

const upstreamDesc = () => config.upstream === 'tcp'
  ? `tcp://${config.upstreamHost}:${config.upstreamPort}`
  : `unix:${config.socketPath}`;

app.get('/', (req, res, next) => {
  if (config.runMode === 'fullstack') return next();   // proxy root to SeaTable
  res.json({
    service: 'seaf-server-relay',
    ok: true,
    wsPath: config.wsPath,
    upstream: upstreamDesc(),
    spawnSeafServer: config.spawnSeafServer,
    activeRelays: relay ? relay.activeCount() : 0,
    totalRelays: relay ? relay.totalCount() : 0,
  });
});
app.get('/healthz', (req, res) => res.send('ok'));

// Probe whether PRoot (userspace chroot via ptrace) works here — decides if we
// can run the x86_64 SeaTable stack on this PaaS without CAP_SYS_CHROOT.
app.get('/ptrace-test', async (req, res) => {
  const readFile = (p) => { try { return fs.readFileSync(p, 'utf8').trim(); } catch { return null; } };
  // fetch proot at runtime (not committed — a bundled ELF may be rejected by the deploy)
  const proot = path.join(config.root, 'proot-x86_64');
  let prootFetch = 'cached';
  if (!fs.existsSync(proot)) {
    try {
      const r = await fetch('https://proot.gitlab.io/proot/bin/proot');
      const buf = Buffer.from(await r.arrayBuffer());
      fs.writeFileSync(proot, buf, { mode: 0o755 });
      prootFetch = `downloaded ${buf.length} bytes`;
    } catch (e) { prootFetch = 'download failed: ' + e.message; }
  }
  const run = (env) => new Promise((resolve) => {
    execFile(proot, ['-0', '/bin/echo', 'PROOT_OK'],
      { timeout: 10000, env: { ...process.env, ...env } },
      (err, stdout, stderr) => resolve({
        ok: !err && (stdout || '').trim() === 'PROOT_OK',
        code: err ? (err.code ?? err.errno ?? null) : 0,
        stdout: (stdout || '').trim().slice(0, 200),
        stderr: (stderr || '').trim().slice(0, 800),
      }));
  });
  res.json({
    uid: process.getuid ? process.getuid() : null,
    ptrace_scope: readFile('/proc/sys/kernel/yama/ptrace_scope'),
    seccomp_status: (readFile('/proc/self/status') || '').split('\n').find((l) => l.startsWith('Seccomp')) || null,
    prootFetch,
    prootExists: fs.existsSync(proot),
    proot_default: fs.existsSync(proot) ? await run({}) : 'no proot',
    proot_no_seccomp: fs.existsSync(proot) ? await run({ PROOT_NO_SECCOMP: '1' }) : 'no proot',
  });
});

// Phase 1: download+extract the x86_64 rootfs and validate PRoot runs its
// binaries. Runs the setup script in the background; poll this endpoint for the
// log. Pass ?restart=1 to re-run.
// Fullstack (PRoot) log
const FS_LOG = path.join(config.root, 'fullstack.log');
app.get('/fullstack-log', (req, res) => {
  let log = null;
  try { log = fs.readFileSync(FS_LOG, 'utf8'); } catch { /* ignore */ }
  res.type('text/plain').send(log || '(no fullstack.log yet)');
});

// Diagnose the in-PRoot SeaTable: listening ports (shared netns), live probes,
// and component logs from the extracted rootfs.
app.get('/proot-status', async (req, res) => {
  const readFile = (p) => { try { return fs.readFileSync(p, 'utf8'); } catch { return null; } };
  const ports = new Set();
  for (const f of ['/proc/net/tcp', '/proc/net/tcp6']) {
    for (const line of (readFile(f) || '').split('\n').slice(1)) {
      const p = line.trim().split(/\s+/);
      if (p[3] === '0A' && p[1]) { const n = parseInt(p[1].split(':')[1], 16); if (n) ports.add(n); }
    }
  }
  const probe = (port) => new Promise((r) => {
    const rq = http.request({ host: '127.0.0.1', port, path: '/', timeout: 5000 }, (rs) => { r(rs.statusCode); rs.resume(); });
    rq.on('error', (e) => r(e.code)); rq.on('timeout', () => { rq.destroy(); r('timeout'); }); rq.end();
  });
  const tcp = (port) => new Promise((r) => {
    const s = net.connect({ port, host: '127.0.0.1', timeout: 5000 });
    s.on('connect', () => { s.destroy(); r('connected'); });
    s.on('error', (e) => r(e.code)); s.on('timeout', () => { s.destroy(); r('timeout'); });
  });
  const L = path.join(config.root, 'rootfs', 'shared', 'seatable', 'logs');
  res.json({
    pod: os.hostname(),
    fullstackRunning: fs.existsSync(path.join(config.root, 'rootfs', 'opt', 'seatable')),
    listening: [...ports].sort((a, b) => a - b),
    tcp_redis6379: await tcp(6379),   // native (apk) listener
    tcp8080: await tcp(8080), tcp8000: await tcp(8000),   // proot listeners
    probe8080: await probe(8080),
    probe8000: await probe(8000),
    gunicorn: (readFile(path.join(L, 'gunicorn.log')) || '').slice(-1500),
    dtableWeb: (readFile(path.join(L, 'dtable_web.log')) || '').slice(-1500),
    seafile: (readFile(path.join(L, 'seafile.log')) || '').slice(-600),
    nginxOut: (readFile(path.join(L, 'nginx.out')) || '').slice(-600),
  });
});

const PROOT_LOG = path.join(config.root, 'proot.log');
app.get('/proot-probe', (req, res) => {
  if (req.query.restart) { try { fs.rmSync(PROOT_LOG, { force: true }); } catch { /* ignore */ } }
  if (!fs.existsSync(PROOT_LOG)) {
    fs.writeFileSync(PROOT_LOG, '');
    const out = fs.openSync(PROOT_LOG, 'a');
    const child = spawn('sh', [path.join(config.root, 'scripts', 'proot-setup.sh')],
      { env: { ...process.env, APPDIR: config.root }, stdio: ['ignore', out, out], detached: true });
    child.unref();
    return res.json({ started: true, pid: child.pid });
  }
  let log = null;
  try { log = fs.readFileSync(PROOT_LOG, 'utf8'); } catch { /* ignore */ }
  res.json({ started: true, done: (log || '').includes('DONE'), log: (log || '').slice(-6000) });
});

// Remote diagnosis: seaf-server + init state, os, and recent seafile.log.
app.get('/status', (req, res) => {
  const readFile = (p) => { try { return fs.readFileSync(p, 'utf8').trim(); } catch { return null; } };
  res.json({
    service: 'seaf-server-relay',
    spawnSeafServer: config.spawnSeafServer,
    upstream: upstreamDesc(),
    init: { state: status.init, detail: status.initDetail, error: status.initError },
    seafServer: {
      state: status.seaf,
      pid: status.seafPid,
      socket: config.socketPath,
      socketExists: fs.existsSync(config.socketPath),
      error: status.seafError,
    },
    recentLog: tailLog(2000),
    db: { host: config.db.host, port: config.db.port, user: config.db.user,
          seafileDb: config.db.seafileDb, ccnetDb: config.db.ccnetDb },
    // discover the PaaS-provided MySQL connection env (values redacted for secrets)
    dbEnv: Object.fromEntries(Object.entries(process.env)
      .filter(([k]) => /mysql|maria|3306|database|(^|_)db(_|$)|_host$|_port$|_addr$/i.test(k))
      .map(([k, v]) => [k, /pass|secret|token|pwd|key/i.test(k) ? '***' : v])),
    os: {
      platform: process.platform, arch: process.arch, node: process.version,
      release: os.release(),
      osRelease: readFile('/etc/os-release'),
      alpine: readFile('/etc/alpine-release'),
    },
  });
});

const FULLSTACK = config.runMode === 'fullstack';

if (FULLSTACK) {
  // Proxy everything (except the diagnostics above) to the in-PRoot nginx :8080.
  const proxy = httpProxy.createProxyServer({ target: 'http://127.0.0.1:8080', ws: true, xfwd: true });
  proxy.on('error', (e, req, res) => {
    if (res && !res.headersSent && res.writeHead) { res.writeHead(502); res.end('SeaTable starting… ' + e.code); }
    else if (res && res.destroy) res.destroy();
  });
  app.use((req, res) => proxy.web(req, res));
  var proxyServer = proxy; // referenced by the upgrade handler below
} else {
  attachFileProxy(app);   // /seafhttp/* -> local fileserver :8082 (relay mode)
}

const server = http.createServer(app);
if (FULLSTACK) {
  server.on('upgrade', (req, socket, head) => proxyServer.ws(req, socket, head));
} else {
  relay = attachRelay(server);
}

async function main() {
  server.listen(config.port, config.host, () => {
    console.log(`[app] listening on http://${config.host}:${config.port}  mode=${config.runMode}`);
  });

  if (FULLSTACK) {
    // Download rootfs + start redis + run the full SeaTable stack under PRoot.
    fs.writeFileSync(FS_LOG, '');
    const out = fs.openSync(FS_LOG, 'a');
    const child = spawn('sh', [path.join(config.root, 'scripts', 'fullstack-paas.sh')],
      { env: { ...process.env, APPDIR: config.root }, stdio: ['ignore', out, out], detached: true });
    child.unref();
    console.log('[fullstack] started (pid', child.pid, ') — see /fullstack-log');
    return;
  }

  if (config.spawnSeafServer) {
    try {
      await initSeaf();   // dirs + conf + DB schema (idempotent)
    } catch (e) {
      console.error('[init] failed:', e.message, '- seaf-server may not start');
    }
    startSeafServer();
    try {
      await waitForSocket();
      console.log('[seaf-server] rpc socket ready:', config.socketPath);
    } catch (e) {
      console.error('[seaf-server]', e.message, '- relay is up; WS relays will fail until seaf-server is reachable');
    }
  } else if (config.upstream === 'tcp') {
    console.log('[relay] relay-only; upstream seaf-server via', upstreamDesc());
  } else {
    console.log('[relay] relay-only; expecting external seaf-server at', config.socketPath);
  }
}

function shutdown() {
  console.log('\n[relay] shutting down');
  stopSeafServer();
  server.close(() => process.exit(0));
  setTimeout(() => process.exit(0), 3000).unref();
}
process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

main();
