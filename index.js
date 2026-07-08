// seaf-server relay (Host-S side of the SeaTable split).
//
//   [app tier] seahub -> /var/run/seafile.sock -> (unix->ws client)
//        == WebSocket over HTTP :3000 ==>
//   [this app] ws -> seaf-server unix socket   (+ spawns native seaf-server)
//
// Runs via `npm start`; listens on :3000 (HTTP health + WS relay at /seaf).
import express from 'express';
import http from 'node:http';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { execFile } from 'node:child_process';
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

app.get('/', (req, res) => {
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
  const proot = path.join(config.root, 'bin', 'proot-x86_64');
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
    prootExists: fs.existsSync(proot),
    proot_default: await run({}),
    proot_no_seccomp: await run({ PROOT_NO_SECCOMP: '1' }),
  });
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

attachFileProxy(app);   // /seafhttp/* -> local fileserver :8082 (files over the single exposed port)

const server = http.createServer(app);
relay = attachRelay(server);

async function main() {
  // Start the HTTP/WS server FIRST so the deployment is always reachable
  // (health checks pass) even if seaf-server can't run on this host.
  server.listen(config.port, config.host, () => {
    console.log(`[relay] listening on http://${config.host}:${config.port}  (WS ${config.wsPath})  upstream=${upstreamDesc()}`);
  });

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
