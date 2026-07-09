#!/bin/sh
# PaaS orchestration: download+extract the x86_64 rootfs, set up redis, then run
# the FULL SeaTable stack under PRoot. seatable-fullstack.sh runs inside proot.
set -u
APPDIR="${APPDIR:-/app}"
ROOTFS="$APPDIR/rootfs"
ASSET="$APPDIR/rootfs.tar.zst"
PROOT="$APPDIR/proot-x86_64"
FULLSTACK="$APPDIR/scripts/seatable-fullstack.sh"
URL="https://github.com/imyaman/apppaas-expressjs-app2/releases/download/rootfs-v1/seatable-rootfs.tar.zst"
log(){ echo "[fullstack $(date +%T)] $*"; }
get(){ if command -v curl >/dev/null 2>&1; then curl -fsSL -o "$2" "$1"; else wget -qO "$2" "$1"; fi; }
# retry a command up to N times (network flakiness / Istio sidecar startup)
retry(){ n="$1"; shift; i=1; while [ "$i" -le "$n" ]; do "$@" && return 0; log "retry $i/$n: $*"; i=$((i+1)); sleep 4; done; return 1; }

# Wait for outbound network. On this PaaS the Istio sidecar isn't ready at boot,
# so egress is refused until it comes up — poll until a fetch succeeds.
log "waiting for network egress (istio sidecar)"
i=1; while [ "$i" -le 60 ]; do
  if get https://proot.gitlab.io/proot/bin/proot "$PROOT" 2>/dev/null && [ -s "$PROOT" ]; then chmod +x "$PROOT"; log "network up; proot fetched"; break; fi
  i=$((i+1)); sleep 4
done
[ -x "$PROOT" ] || { log "network never came up — abort"; exit 1; }

# tools
command -v redis-server >/dev/null 2>&1 || { log "apk add redis bash zstd"; retry 20 apk add --no-cache redis bash zstd >/dev/null 2>&1 || log "apk failed"; }

# rootfs
if [ ! -e "$ROOTFS/opt/seatable" ]; then
  [ -f "$ASSET" ] || { log "download rootfs (~865MB)"; retry 20 get "$URL" "$ASSET" && log "downloaded" || log "download FAILED"; }
  log "extract rootfs"; mkdir -p "$ROOTFS"
  zstd -dc "$ASSET" | tar -x -C "$ROOTFS" && log "extracted" || log "extract FAILED"
fi
# clear stale runtime state
rm -f "$ROOTFS"/var/run/*.pid "$ROOTFS"/var/run/seafile.sock 2>/dev/null
find "$ROOTFS/opt/seatable/db-data" "$ROOTFS/shared/seatable/db-data" -name LOCK -delete 2>/dev/null

# redis
redis-server --daemonize yes --bind 127.0.0.1 --port 6379 --save "" >/dev/null 2>&1
log "redis: $(redis-cli ping 2>&1)"

# seatable env. Secrets (DB host/user/password, JWT, admin password) come from
# PaaS env vars — NOT hardcoded (this repo is public). Only non-sensitive
# structural defaults are set here.
export SEATABLE_MYSQL_DB_HOST="${SEAF_DB_HOST:?set SEAF_DB_HOST}" SEATABLE_MYSQL_DB_PORT="${SEAF_DB_PORT:-3306}"
export SEATABLE_MYSQL_DB_USER="${SEAF_DB_USER:?set SEAF_DB_USER}" SEATABLE_MYSQL_DB_PASSWORD="${SEAF_DB_PASSWORD:?set SEAF_DB_PASSWORD}"
export SEATABLE_MYSQL_DB_SEAFILE_DB_NAME="${SEAF_DB_SEAFILE_NAME:-apppaas_app1}"
export SEATABLE_MYSQL_DB_CCNET_DB_NAME="${SEAF_DB_CCNET_NAME:-apppaas_app1}"
export SEATABLE_MYSQL_DB_DTABLE_DB_NAME="${SEAF_DB_DTABLE_NAME:-apppaas_app1}"
export REDIS_HOST=127.0.0.1 REDIS_PORT=6379 REDIS_PASSWORD=
export JWT_PRIVATE_KEY="${JWT_PRIVATE_KEY:?set JWT_PRIVATE_KEY}"
export SEATABLE_SERVER_HOSTNAME="${SEATABLE_SERVER_HOSTNAME:-localhost}" SEATABLE_SERVER_PROTOCOL="${SEATABLE_SERVER_PROTOCOL:-http}"
export SEATABLE_ADMIN_EMAIL="${SEATABLE_ADMIN_EMAIL:?set SEATABLE_ADMIN_EMAIL}" SEATABLE_ADMIN_PASSWORD="${SEATABLE_ADMIN_PASSWORD:?set SEATABLE_ADMIN_PASSWORD}"
export TIME_ZONE="${TIME_ZONE:-Asia/Seoul}"
export PROOT_NO_SECCOMP=1

log "launch seatable under proot"
exec "$PROOT" -0 -r "$ROOTFS" -b /proc -b /dev -b /sys -b "$FULLSTACK:/fullstack.sh" -w / \
  /bin/bash /fullstack.sh
