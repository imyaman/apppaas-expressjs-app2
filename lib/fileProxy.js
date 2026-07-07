// HTTP proxy for the seafile fileserver.
// The PaaS exposes only port 3000, but seafile's file up/download runs on the
// integrated fileserver at :8082. So proxy /seafhttp/* -> 127.0.0.1:8082,
// stripping the /seafhttp prefix (same as the app-tier nginx did). Streams
// bodies both ways, so large files work.
import http from 'node:http';

const FILESERVER_HOST = process.env.SEAF_FILESERVER_HOST || '127.0.0.1';
const FILESERVER_PORT = parseInt(process.env.SEAF_FILESERVER_PORT || '8082', 10);

export function attachFileProxy(app) {
  // app.use('/seafhttp', ...) strips the mount prefix, so req.url is the
  // remainder the fileserver expects at its root.
  app.use('/seafhttp', (req, res) => {
    const upstream = http.request({
      host: FILESERVER_HOST,
      port: FILESERVER_PORT,
      method: req.method,
      path: req.url || '/',
      headers: req.headers,
    }, (up) => {
      res.writeHead(up.statusCode || 502, up.headers);
      up.pipe(res);
    });
    upstream.on('error', (e) => {
      if (!res.headersSent) res.status(502);
      res.end(`fileserver unreachable: ${e.message}`);
    });
    req.pipe(upstream);
  });
}
