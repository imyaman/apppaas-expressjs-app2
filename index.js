// seaf-server relay (Host-S side of the SeaTable split).
//
//   [app tier] seahub -> /var/run/seafile.sock -> (unix->ws client)
//        == WebSocket over HTTP :3000 ==>
//   [this app] ws -> seaf-server unix socket   (+ spawns native seaf-server)
//
// Runs via `npm start`; listens on :3000 (HTTP health + WS relay at /seaf).
import express from 'express';
import http from 'node:http';
import config from './lib/config.js';
import { startSeafServer, waitForSocket, stopSeafServer } from './lib/seafServer.js';
import { attachRelay } from './lib/relay.js';
import { initSeaf } from './lib/initSeaf.js';

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
