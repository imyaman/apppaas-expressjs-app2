// First-run initialization for a self-hosted seaf-server:
//   - create the conf/ccnet/data/run/log dirs (+ library-template)
//   - write a minimal seafile.conf
//   - create the databases and load the SQL schema if empty
// seaf-server additionally needs JWT_PRIVATE_KEY in its env (set in seafServer.js).
import fs from 'node:fs';
import path from 'node:path';
import mysql from 'mysql2/promise';
import config from './config.js';

const SQL_DIR = path.join(config.root, 'sql');

// database -> schema file. Loaded only when the database has no tables yet.
// seaf-server needs seafile_db + ccnet_db; dtable_db is the app tier's (loaded
// only when INIT_DTABLE_DB=true, since the app tier normally inits it).
function schemas() {
  const list = [
    { name: config.db.seafileDb, file: 'seafile.sql' },
    { name: config.db.ccnetDb, file: 'ccnet.sql' },
  ];
  if (config.initDtableDb) list.push({ name: config.db.dtableDb, file: 'dtable.sql' });
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

async function tableCount(conn, db) {
  const [rows] = await conn.query(
    'SELECT COUNT(*) AS n FROM information_schema.tables WHERE table_schema = ?', [db]);
  return rows[0].n;
}

export async function ensureSchema() {
  const { host, port, user, password } = config.db;
  const conn = await mysql.createConnection({
    host, port: Number(port), user, password, multipleStatements: true,
  });
  try {
    for (const s of schemas()) {
      try {
        await conn.query(`CREATE DATABASE IF NOT EXISTS \`${s.name}\` CHARACTER SET utf8mb4`);
        const n = await tableCount(conn, s.name);
        if (n > 0) { console.log(`[init] db ${s.name}: ${n} tables present — skip`); continue; }
        const ddl = fs.readFileSync(path.join(SQL_DIR, s.file), 'utf8');
        await conn.query(`USE \`${s.name}\``);
        await conn.query(ddl);
        console.log(`[init] db ${s.name}: loaded ${s.file} -> ${await tableCount(conn, s.name)} tables`);
      } catch (e) {
        console.error(`[init] db ${s.name}: schema load failed (${e.code || e.message})`);
        throw e;  // seafile_db/ccnet_db are required — fail loudly
      }
    }
  } finally {
    await conn.end();
  }
}

export async function initSeaf() {
  ensureDirs();
  ensureConf();
  if (!config.jwtPrivateKey) {
    console.error('[init] WARNING: JWT_PRIVATE_KEY is empty — seaf-server will fail to start. Set it (must match the app tier).');
  }
  await ensureSchema();
}
