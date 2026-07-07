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

## Deployment note — Alpine / musl PaaS

`seaf-server` is a **glibc (Ubuntu) binary and will NOT run on Alpine/musl**, and this
PaaS is **stateless** (no persistent volume) — unsuitable for seaf-server's storage.
So on the PaaS run this app as a **relay only** to a seaf-server on a glibc host:

```
SPAWN_SEAFSERVER=false
SEAF_UPSTREAM=tcp
SEAF_UPSTREAM_HOST=<seaf-server host>
SEAF_UPSTREAM_PORT=9200
```

On the seaf-server host, expose its unix socket over TCP, e.g.:

```
socat TCP-LISTEN:9200,fork,reuseaddr UNIX-CONNECT:/opt/.../run/seafile.sock
```

(For an all-in-one glibc host, instead set `SPAWN_SEAFSERVER=true` and this app runs
seaf-server itself — see `setup-seafile-native.sh`. On musl you may bundle a glibc
loader and point `SEAF_LD_SO` at it, but a glibc host is simpler.)

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
| `SPAWN_SEAFSERVER` | `false` | `true` = run seaf-server here (glibc host only) |
| `SEAF_LD_SO` | | optional bundled glibc `ld-linux` to run seaf-server on musl |
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
