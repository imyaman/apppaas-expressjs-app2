# seaf-server relay

WebSocket relay for the SeaTable split. seahub (app tier) talks to `seaf-server`
over a searpc **unix socket**; this app carries that socket across the network as a
**WebSocket**, so seaf-server can live on a different host.

```
[app tier] seahub ─ /var/run/seafile.sock ─ client/unix-to-ws.js
      ══ WebSocket over HTTP :3000 (/seaf) ══▶
[this app] bin/www ─┬─ upstream=unix ─▶ local seaf-server socket   (+ can spawn seaf-server)
                    └─ upstream=tcp  ─▶ remote seaf-server exposed over TCP (e.g. socat)
```

searpc is a raw ordered byte stream; each WS connection maps 1:1 to a fresh upstream
connection and bytes are forwarded verbatim (byte-integrity verified).

## Run

PaaS launches `node ./bin/www --host 0.0.0.0 --port 3000` (also `npm start` / `npm run serve`).

- `GET /` — JSON status. `GET /healthz` — `ok`. WS endpoint: `ws://<host>:3000/seaf`.

## Deployment — run seaf-server on the Alpine PaaS

`seaf-server` is a glibc (Ubuntu) binary, but it **runs on Alpine/musl** via the
bundled glibc loader in `seafile-native/glibc/` (auto-detected — verified inside
`node:20-alpine`). On first start the app also initializes itself: creates the
conf/data dirs, writes `seafile.conf`, and loads the `seafile_db` + `ccnet_db`
schema into MySQL. Set:

```
SPAWN_SEAFSERVER=true
JWT_PRIVATE_KEY=<shared secret, must match the app tier>   # required
SEAF_DB_HOST=<mysql host>       # e.g. the PaaS MySQL
SEAF_DB_PORT=3306
SEAF_DB_USER=<user>             # needs CREATE DATABASE + DDL on the seafile/ccnet DBs
SEAF_DB_PASSWORD=<pw>
# optional overrides: SEAF_DB_SEAFILE_NAME / _CCNET_NAME / _DTABLE_NAME
# data/conf live under ./ (ephemeral on a stateless PaaS — fine for testing;
# for durability use seafile's S3 backend or a persistent volume)
```

Note the PaaS is **stateless** — `seafile-data` (object storage) is lost on redeploy.
That is fine for testing; for durable storage configure seafile's S3 backend.

### Alternative — relay only

If seaf-server runs on a separate glibc host instead, set `SPAWN_SEAFSERVER=false`
and relay to it over TCP:

```
SEAF_UPSTREAM=tcp
SEAF_UPSTREAM_HOST=<seaf-server host>
SEAF_UPSTREAM_PORT=9200
```
and on that host: `socat TCP-LISTEN:9200,fork,reuseaddr UNIX-CONNECT:/.../run/seafile.sock`

## Environment variables

| var | default | notes |
|-----|---------|-------|
| `PORT` / `--port` | `3000` | HTTP + WS listener |
| `HOST` / `--host` | `0.0.0.0` | |
| `WS_PATH` | `/seaf` | WebSocket path |
| `SEAF_UPSTREAM` | `unix` | `unix` = local socket, `tcp` = remote seaf-server |
| `SEAF_UPSTREAM_HOST` | `127.0.0.1` | when `tcp` |
| `SEAF_UPSTREAM_PORT` | `9200` | when `tcp` |
| `SEAF_SOCKET_PATH` | `RUN_DIR/seafile.sock` | when `unix` |
| `SPAWN_SEAFSERVER` | `false` | `true` = run seaf-server here (+ auto init conf/DB) |
| `SEAF_LD_SO` | auto | glibc `ld-linux` to run seaf-server on musl; auto-detected at `seafile-native/glibc/` |
| `INIT_DTABLE_DB` | `false` | also load the app-tier `dtable_db` schema |
| `SEAFILE_NATIVE_DIR` | `./seafile-native` | `bin/` + `lib/` (spawn mode) |
| `RUN_DIR` `LOG_DIR` | `./run` `./logs` | |
| `SEAFILE_CONF_DIR` `SEAFILE_DATA_DIR` `CCNET_CONF_DIR` | `./conf` `./seafile-data` `./ccnet` | spawn mode |
| `SEAF_DB_HOST` … | `127.0.0.1` … | spawn mode; use a directly reachable IP (a podman loopback port-forward triggers seaf-server `errno 115`) |
| `JWT_PRIVATE_KEY` | | must match the app tier |
| `SEAF_REDIS_HOST` / `_PORT` / `_PASSWORD` | | optional |

## App-tier counterpart

`client/unix-to-ws.js` runs next to seahub: listens on the unix socket seahub expects
and bridges to this relay.

```bash
SEAF_SOCKET_PATH=/var/run/seafile.sock \
RELAY_WS_URL=wss://<relay-public-address>/seaf \
npm run client
```

Also point the app-tier nginx `/seafhttp` upstream at the seaf-server host's `:8082`
(integrated fileserver, HTTP), and share the same `JWT_PRIVATE_KEY` + MariaDB/Redis.

## setup-seafile-native.sh

Populates `./seafile-native/` from the SeaTable image (needs podman). Only for
`SPAWN_SEAFSERVER=true` on a glibc host. Git-ignored by default (71 MB).
