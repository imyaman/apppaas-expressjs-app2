// First-run initialization for a self-hosted seaf-server:
//   - create the conf/ccnet/data/run/log dirs (+ library-template)
//   - write a minimal seafile.conf
//   - create the databases and load the SQL schema if empty
// seaf-server additionally needs JWT_PRIVATE_KEY in its env (set in seafServer.js).
import fs from 'node:fs';
import path from 'node:path';
import mysql from 'mysql2/promise';
import config from './config.js';
import { status } from './status.js';

const SQL_DIR = path.join(config.root, 'sql');

// (database, schema file, sentinel table). Detected per-schema by its sentinel
// table, so multiple schemas can share ONE database (e.g. when the DB user only
// has access to a single database and cannot CREATE new ones). No table-name
// collisions exist between seafile/ccnet/dtable.
function schemas() {
  const list = [
    { name: config.db.seafileDb, file: 'seafile.sql', sentinel: 'Repo' },
    { name: config.db.ccnetDb, file: 'ccnet.sql', sentinel: 'EmailUser' },
  ];
  if (config.initDtableDb) list.push({ name: config.db.dtableDb, file: 'dtable.sql', sentinel: 'django_migrations' });
  return list;
}

export function ensureDirs() {
  const dirs = [
    config.confDir, config.ccnetDir, config.dataDir,
    path.join(config.dataDir, 'library-template'),
    config.runDir, config.logDir,
  ];
  for (const d of dirs) fs.mkdirSync(d, { recursive: true });
}

export function ensureConf() {
  const f = path.join(config.confDir, 'seafile.conf');
  if (!fs.existsSync(f)) {
    fs.writeFileSync(f, '[fileserver]\nport=8082\n\n[history]\nkeep_days = 60\n');
    console.log('[init] wrote', f);
  }
}

async function tableExists(conn, db, table) {
  const [rows] = await conn.query(
    'SELECT COUNT(*) AS n FROM information_schema.tables WHERE table_schema = ? AND table_name = ?',
    [db, table]);
  return rows[0].n > 0;
}

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

// Wait for MySQL to accept connections (handles the app-starts-before-db race,
// like SeaTable's init_sql.py wait_for_mysql). Retries on connect-level errors.
async function connectWithRetry(opts, attempts = 30, delayMs = 2000) {
  let lastErr;
  for (let i = 1; i <= attempts; i++) {
    try {
      return await mysql.createConnection({ ...opts, connectTimeout: 5000 });
    } catch (e) {
      lastErr = e;
      status.initDetail = `waiting for mysql (${i}/${attempts}): ${e.code || e.message}`;
      console.error(`[init] mysql not ready (${e.code || e.message}) — retry ${i}/${attempts}`);
      await sleep(delayMs);
    }
  }
  throw lastErr;
}

export async function ensureSchema() {
  const { host, port, user, password } = config.db;
  const conn = await connectWithRetry({
    host, port: Number(port), user, password, multipleStatements: true,
  });
  const detail = [];
  try {
    for (const s of schemas()) {
      try {
        // The DB is expected to already exist; the user may lack CREATE DATABASE.
        try { await conn.query(`CREATE DATABASE IF NOT EXISTS \`${s.name}\` CHARACTER SET utf8mb4`); }
        catch { /* no privilege / already exists — proceed */ }
        if (await tableExists(conn, s.name, s.sentinel)) {
          console.log(`[init] ${s.name}.${s.sentinel} present — skip ${s.file}`);
          detail.push(`${s.file}:kept`);
          continue;
        }
        const ddl = fs.readFileSync(path.join(SQL_DIR, s.file), 'utf8');
        await conn.query(`USE \`${s.name}\``);
        await conn.query(ddl);
        console.log(`[init] ${s.name}: loaded ${s.file}`);
        detail.push(`${s.file}:loaded`);
      } catch (e) {
        console.error(`[init] ${s.file} -> ${s.name}: ${e.code || e.message}`);
        throw e;  // seafile/ccnet schema is required — fail loudly
      }
    }
  } finally {
    await conn.end();
  }
  return detail.join(', ');
}

export async function initSeaf() {
  try {
    ensureDirs();
    ensureConf();
    if (!config.jwtPrivateKey) {
      console.error('[init] WARNING: JWT_PRIVATE_KEY is empty — seaf-server will fail to start. Set it (must match the app tier).');
    }
    const detail = await ensureSchema();
    status.init = 'ok';
    status.initDetail = detail;
  } catch (e) {
    status.init = 'failed';
    status.initError = `${e.code || ''} ${e.message}`.trim();
    throw e;
  }
}
