// WebSocket <-> unix-socket bridge.
// Each WS connection maps to one fresh connection to seaf-server's searpc
// unix socket. searpc is a raw ordered byte stream, so we forward bytes
// verbatim in both directions; WebSocket preserves order and framing.
import { WebSocketServer } from 'ws';
import net from 'node:net';
import config from './config.js';

export function attachRelay(server) {
  const wss = new WebSocketServer({ server, path: config.wsPath });
  let active = 0;
  let total = 0;

  const connectUpstream = () => config.upstream === 'tcp'
    ? net.connect(config.upstreamPort, config.upstreamHost)
    : net.connect(config.socketPath);

  wss.on('connection', (ws, req) => {
    active += 1; total += 1;
    const peer = req.socket.remoteAddress;
    const sock = connectUpstream();
    let closed = false;

    const close = (why) => {
      if (closed) return;
      closed = true;
      active -= 1;
      try { sock.destroy(); } catch { /* ignore */ }
      try { ws.close(); } catch { /* ignore */ }
      if (why) console.error(`[relay] closed (${why}) peer=${peer} active=${active}`);
    };

    // seaf-server -> WebSocket. Apply backpressure against the WS buffer.
    sock.on('data', (buf) => {
      if (ws.readyState !== ws.OPEN) return;
      ws.send(buf, { binary: true });
      if (ws.bufferedAmount > 1 << 20) {
        sock.pause();
        const resume = setInterval(() => {
          if (closed) { clearInterval(resume); return; }
          if (ws.bufferedAmount < 1 << 18) { clearInterval(resume); sock.resume(); }
        }, 20);
      }
    });
    sock.on('error', (e) => close(`socket:${e.code || e.message}`));
    sock.on('close', () => close());

    // WebSocket -> seaf-server. Apply backpressure against the socket buffer.
    ws.on('message', (data) => {
      const buf = Buffer.isBuffer(data) ? data : Buffer.from(data);
      const ok = sock.write(buf);
      if (!ok) { ws.pause?.(); sock.once('drain', () => ws.resume?.()); }
    });
    ws.on('error', (e) => close(`ws:${e.message}`));
    ws.on('close', () => close());
  });

  wss.on('error', (e) => console.error('[relay] server error:', e.message));

  return {
    wss,
    activeCount: () => active,
    totalCount: () => total,
  };
}
