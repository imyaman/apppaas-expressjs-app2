// Spawn and supervise the native seaf-server process.
// seaf-server serves the integrated Go fileserver on :8082 and creates the
// searpc unix socket (seafile.sock) that the relay bridges over WebSocket.
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import config from './config.js';

let child = null;
let stopping = false;
let restarts = 0;
let daemonTimer = null;

function pidFilePath() { return path.join(config.runDir, 'seafile.pid'); }
function readDaemonPid() {
  try { return parseInt(fs.readFileSync(pidFilePath(), 'utf8').trim(), 10) || 0; }
  catch { return 0; }
}
function isAlive(pid) {
  if (!pid) return false;
  try { process.kill(pid, 0); return true; } catch (e) { return e.code === 'EPERM'; }
}
// seaf-server double-forks; the daemon re-parents away. Watch it via its pid file.
function monitorDaemon(pid) {
  if (daemonTimer) clearInterval(daemonTimer);
  daemonTimer = setInterval(() => {
    if (stopping) { clearInterval(daemonTimer); return; }
    if (!isAlive(pid)) {
      clearInterval(daemonTimer); daemonTimer = null;
      console.error('[seaf-server] daemon died; respawning');
      startSeafServer();
    }
  }, 5000);
}

function buildEnv() {
  const c = config;
  const libDir = path.join(c.nativeDir, 'lib');
  const binDir = path.join(c.nativeDir, 'bin');
  const env = { ...process.env };

  // bundled libraries first (image is Ubuntu-built; libsasl2 etc. are bundled).
  // glibcDir carries the loader + glibc for musl hosts (Alpine).
  const glibcDir = path.join(c.nativeDir, 'glibc');
  env.LD_LIBRARY_PATH = [libDir, glibcDir, '/usr/lib/x86_64-linux-gnu/nss', process.env.LD_LIBRARY_PATH]
    .filter(Boolean).join(':');
  env.PATH = [binDir, process.env.PATH].filter(Boolean).join(':');

  env.CCNET_CONF_DIR = c.ccnetDir;
  env.SEAFILE_CONF_DIR = c.dataDir;
  env.SEAFILE_CENTRAL_CONF_DIR = c.confDir;
  env.SEAFILE_RPC_PIPE_PATH = c.runDir;
  env.ENABLE_GO_FILESERVER = 'true';

  env.SEAFILE_MYSQL_DB_HOST = c.db.host;
  env.SEAFILE_MYSQL_DB_PORT = String(c.db.port);
  env.SEAFILE_MYSQL_DB_USER = c.db.user;
  env.SEAFILE_MYSQL_DB_PASSWORD = c.db.password;
  env.SEAFILE_MYSQL_DB_SEAFILE_DB_NAME = c.db.seafileDb;
  env.SEAFILE_MYSQL_DB_CCNET_DB_NAME = c.db.ccnetDb;
  env.SEAFILE_MYSQL_DB_DTABLE_DB_NAME = c.db.dtableDb;

  if (c.jwtPrivateKey) env.JWT_PRIVATE_KEY = c.jwtPrivateKey;
  if (c.redis.host) {
    env.REDIS_HOST = c.redis.host;
    env.REDIS_PORT = String(c.redis.port);
    env.REDIS_PASSWORD = c.redis.password;
  }
  return env;
}

const MAX_RESTARTS = 5;   // give up after this many failures (e.g. glibc binary on musl)

// Returns { cmd, args } — routed through a bundled glibc loader when available
// so the glibc-built binary runs on a musl host (Alpine). The loader is used if
// SEAF_LD_SO is set, or auto-detected at seafile-native/glibc/ld-linux-x86-64.so.2
// (verified working inside node:20-alpine).
function buildCommand() {
  const c = config;
  const bin = path.join(c.nativeDir, 'bin', 'seaf-server');
  const libPath = [path.join(c.nativeDir, 'lib'), path.join(c.nativeDir, 'glibc')].join(':');
  const seafArgs = [
    '-F', c.confDir, '-d', c.dataDir,
    '-l', path.join(c.logDir, 'seafile.log'),
    '-P', path.join(c.runDir, 'seafile.pid'),
    '-p', c.runDir, '-',
  ];
  let ldSo = process.env.SEAF_LD_SO;
  if (!ldSo) {
    const bundled = path.join(c.nativeDir, 'glibc', 'ld-linux-x86-64.so.2');
    if (fs.existsSync(bundled)) ldSo = bundled;
  }
  if (ldSo) {
    return { cmd: ldSo, args: ['--library-path', libPath, bin, ...seafArgs], bin };
  }
  return { cmd: bin, args: seafArgs, bin };
}

export function startSeafServer() {
  const c = config;
  fs.mkdirSync(c.runDir, { recursive: true });
  fs.mkdirSync(c.logDir, { recursive: true });

  const { cmd, args, bin } = buildCommand();
  if (!fs.existsSync(bin)) {
    console.error(`[seaf-server] binary not found: ${bin}`);
    console.error('[seaf-server] provide seafile-native/ (setup-seafile-native.sh) or set SEAFILE_NATIVE_DIR, or SPAWN_SEAFSERVER=false');
    return null;   // do not crash the process; relay still serves
  }

  // clear any stale socket so waitForSocket() detects the fresh one
  try { fs.rmSync(c.socketPath, { force: true }); } catch { /* ignore */ }

  console.log(`[seaf-server] spawn: ${cmd} ${args.join(' ')}`);
  child = spawn(cmd, args, { env: buildEnv(), stdio: ['ignore', 'inherit', 'inherit'] });

  child.on('exit', async (code, sig) => {
    child = null;
    if (stopping) return;
    // seaf-server daemonizes: the launcher exits 0 while the real daemon keeps
    // running (writes its pid file). Adopt+monitor it instead of restarting.
    for (let i = 0; i < 20; i++) {
      const pid = readDaemonPid();
      if (pid && isAlive(pid)) {
        console.log(`[seaf-server] running as daemon pid ${pid}`);
        restarts = 0;
        monitorDaemon(pid);
        return;
      }
      await new Promise((r) => setTimeout(r, 150));
    }
    // genuine startup failure
    restarts += 1;
    if (restarts > MAX_RESTARTS) {
      console.error(`[seaf-server] gave up after ${MAX_RESTARTS} failed starts. `
        + 'On a musl host (Alpine) the glibc binary cannot run — set SEAF_LD_SO to a '
        + 'bundled glibc loader, or run seaf-server elsewhere and use SEAF_UPSTREAM=tcp.');
      return;
    }
    const delay = Math.min(10000, 500 * restarts);
    console.error(`[seaf-server] exited (code=${code} signal=${sig}); restarting in ${delay}ms (#${restarts})`);
    setTimeout(startSeafServer, delay);
  });
  child.on('error', (e) => console.error('[seaf-server] spawn error:', e.message));
  return child;
}

// Resolves once the rpc socket exists (seaf-server ready to accept RPC).
export function waitForSocket(timeoutMs = 20000) {
  const c = config;
  return new Promise((resolve, reject) => {
    const start = Date.now();
    const iv = setInterval(() => {
      let ok = false;
      try { ok = fs.statSync(c.socketPath).isSocket(); } catch { /* not yet */ }
      if (ok) { clearInterval(iv); resolve(true); }
      else if (Date.now() - start > timeoutMs) {
        clearInterval(iv);
        reject(new Error(`seafile.sock not created within ${timeoutMs}ms at ${c.socketPath}`));
      }
    }, 200);
  });
}

export function stopSeafServer() {
  stopping = true;
  if (daemonTimer) { clearInterval(daemonTimer); daemonTimer = null; }
  if (child) { try { child.kill('SIGTERM'); } catch { /* ignore */ } }
  const pid = readDaemonPid();
  if (pid && isAlive(pid)) { try { process.kill(pid, 'SIGTERM'); } catch { /* ignore */ } }
}
