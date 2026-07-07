// App-tier counterpart of the relay (the "python program" in the diagram,
// implemented in Node for symmetry / testing).
//
// Listens on a unix socket where seahub expects seaf-server (SEAFILE_RPC_PIPE_PATH
// /seafile.sock). For each incoming connection it opens a WebSocket to the
// remote relay and bridges bytes. Deploy this next to seahub (app tier) and
// point RELAY_WS_URL at the relay's public address.
//
//   SEAF_SOCKET_PATH=/var/run/seafile.sock \
//   RELAY_WS_URL=wss://<relay-address>/seaf \
//   node client/unix-to-ws.js
import net from 'node:net';
import fs from 'node:fs';
import { WebSocket } from 'ws';

const SOCK = process.env.SEAF_SOCKET_PATH || '/var/run/seafile.sock';
const URL = process.env.RELAY_WS_URL || 'ws://127.0.0.1:3000/seaf';

try { fs.rmSync(SOCK, { force: true }); } catch { /* ignore */ }

const server = net.createServer((conn) => {
  const ws = new WebSocket(URL, { perMessageDeflate: false });
  const queue = [];
  let open = false;
  let closed = false;

  const close = () => {
    if (closed) return;
    closed = true;
    try { conn.destroy(); } catch { /* ignore */ }
    try { ws.close(); } catch { /* ignore */ }
  };

  ws.on('open', () => {
    open = true;
    for (const b of queue) ws.send(b, { binary: true });
    queue.length = 0;
  });
  ws.on('message', (data) => {
    const buf = Buffer.isBuffer(data) ? data : Buffer.from(data);
    conn.write(buf);
  });
  ws.on('error', (e) => { console.error('[client] ws error:', e.message); close(); });
  ws.on('close', close);

  conn.on('data', (b) => { if (open) ws.send(b, { binary: true }); else queue.push(b); });
  conn.on('error', close);
  conn.on('close', close);
});

server.on('error', (e) => { console.error('[client] listen error:', e.message); process.exit(1); });
server.listen(SOCK, () => {
  try { fs.chmodSync(SOCK, 0o666); } catch { /* ignore */ }
  console.log(`[client] unix ${SOCK}  ->  ws ${URL}`);
});
