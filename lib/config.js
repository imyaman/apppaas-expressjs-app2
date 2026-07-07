// Configuration for the seaf-server relay, sourced from environment variables.
// Defaults let it run self-contained; override per deployment.
import path from 'node:path';

const ROOT = path.resolve(import.meta.dirname, '..');
const env = process.env;
const bool = (v, d) => (v === undefined || v === '') ? d : /^(1|true|yes|on)$/i.test(v);

// The PaaS launches `node ./bin/www --host 0.0.0.0 --port 3000`; honor those flags.
function argFlag(name) {
  const i = process.argv.indexOf(`--${name}`);
  return (i !== -1 && process.argv[i + 1] && !process.argv[i + 1].startsWith('--'))
    ? process.argv[i + 1] : undefined;
}

const RUN_DIR = env.RUN_DIR || path.join(ROOT, 'run');
const NATIVE_DIR = env.SEAFILE_NATIVE_DIR || path.join(ROOT, 'seafile-native');

export const config = {
  root: ROOT,

  // HTTP + WebSocket listener (PaaS requires :3000). Precedence: --port > PORT > 3000.
  port: parseInt(argFlag('port') || env.PORT || '3000', 10),
  host: argFlag('host') || env.HOST || '0.0.0.0',
  wsPath: env.WS_PATH || '/seaf',

  // Upstream seaf-server rpc endpoint.
  //   'unix' (default): local seafile.sock (spawned here or by an external process)
  //   'tcp'           : remote seaf-server whose socket is exposed over TCP
  //                     (SEAF_UPSTREAM_HOST:SEAF_UPSTREAM_PORT) — used when this
  //                     app runs where seaf-server cannot (e.g. Alpine/musl PaaS).
  upstream: (env.SEAF_UPSTREAM || 'unix').toLowerCase(),
  upstreamHost: env.SEAF_UPSTREAM_HOST || '127.0.0.1',
  upstreamPort: parseInt(env.SEAF_UPSTREAM_PORT || '9200', 10),

  // Load the dtable_db schema too (app tier's DB). Off by default — the app
  // tier normally inits it; this app only needs seafile_db + ccnet_db.
  initDtableDb: bool(env.INIT_DTABLE_DB, false),

  // seaf-server process management. Default OFF: only spawn where a glibc
  // userland is available. On the Alpine PaaS keep this false and relay to a
  // remote seaf-server via SEAF_UPSTREAM=tcp.
  spawnSeafServer: bool(env.SPAWN_SEAFSERVER, false),
  nativeDir: NATIVE_DIR,                 // contains bin/ and lib/ (extracted from the image)
  runDir: RUN_DIR,                       // seaf-server -p (rpc pipe dir) + pid
  logDir: env.LOG_DIR || path.join(ROOT, 'logs'),
  socketPath: env.SEAF_SOCKET_PATH || path.join(RUN_DIR, 'seafile.sock'),

  // seaf-server data / config locations (must be provisioned in the deploy env)
  confDir: env.SEAFILE_CONF_DIR || path.join(ROOT, 'conf'),        // central conf (seafile.conf, ...)
  dataDir: env.SEAFILE_DATA_DIR || path.join(ROOT, 'seafile-data'),
  ccnetDir: env.CCNET_CONF_DIR || path.join(ROOT, 'ccnet'),

  // Shared MariaDB. NOTE: use a directly-reachable host/IP, NOT a podman
  // loopback port-forward (that triggers seaf-server errno 115 / EINPROGRESS).
  db: {
    host: env.SEAF_DB_HOST || '127.0.0.1',
    port: env.SEAF_DB_PORT || '3306',
    user: env.SEAF_DB_USER || 'root',
    password: env.SEAF_DB_PASSWORD || '',
    seafileDb: env.SEAF_DB_SEAFILE_NAME || 'seafile_db',
    ccnetDb: env.SEAF_DB_CCNET_NAME || 'ccnet_db',
    dtableDb: env.SEAF_DB_DTABLE_NAME || 'dtable_db',
  },

  // Shared secret; must match the app tier for fileserver token verification.
  jwtPrivateKey: env.JWT_PRIVATE_KEY || '',

  // Optional Redis (seaf-server cache).
  redis: {
    host: env.SEAF_REDIS_HOST || '',
    port: env.SEAF_REDIS_PORT || '6379',
    password: env.SEAF_REDIS_PASSWORD || '',
  },
};

export default config;
