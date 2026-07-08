#!/bin/sh
# Phase 1: download + extract the x86_64 SeaTable rootfs, then validate that
# PRoot can run its binaries on this (Alpine/musl) PaaS. Logs to stdout.
set -u
APPDIR="${APPDIR:-/app}"
ROOTFS="$APPDIR/rootfs"
ASSET="$APPDIR/rootfs.tar.zst"
PROOT="$APPDIR/proot-x86_64"
URL="https://github.com/imyaman/apppaas-expressjs-app2/releases/download/rootfs-v1/seatable-rootfs.tar.zst"
log(){ echo "[proot-setup $(date +%T)] $*"; }
get(){ if command -v curl >/dev/null 2>&1; then curl -fsSL -o "$2" "$1"; else wget -qO "$2" "$1"; fi; }

log "tools: tar=$(command -v tar) wget=$(command -v wget) curl=$(command -v curl) zstd=$(command -v zstd) apk=$(command -v apk)"
log "disk: $(df -h "$APPDIR" 2>/dev/null | tail -1)"

# proot
if [ ! -x "$PROOT" ]; then log "fetch proot"; get https://proot.gitlab.io/proot/bin/proot "$PROOT" && chmod +x "$PROOT"; fi
log "proot: $("$PROOT" --version 2>&1 | head -1)"

# rootfs asset
if [ ! -f "$ASSET" ]; then log "download rootfs (~865MB)..."; get "$URL" "$ASSET" && log "downloaded" || log "download FAILED"; fi
log "asset bytes: $(wc -c < "$ASSET" 2>/dev/null)"

# ensure zstd
if ! command -v zstd >/dev/null 2>&1; then
  log "no zstd -> apk add"; apk add --no-cache zstd >/dev/null 2>&1 && log "apk zstd ok" || log "apk zstd FAILED"
fi

# extract
if [ ! -e "$ROOTFS/opt/seatable" ]; then
  log "extracting to $ROOTFS ..."
  mkdir -p "$ROOTFS"
  if command -v zstd >/dev/null 2>&1; then
    zstd -dc "$ASSET" | tar -x -C "$ROOTFS" && log "extract ok (zstd|tar)" || log "extract FAILED (zstd|tar)"
  else
    tar --zstd -xf "$ASSET" -C "$ROOTFS" && log "extract ok (tar --zstd)" || log "extract FAILED (no zstd)"
  fi
fi
log "rootfs/opt/seatable: $(ls "$ROOTFS/opt/seatable" 2>&1 | tr '\n' ' ' | head -c 200)"

# ---- PRoot binary validation ----
log "== proot: python3 --version =="
"$PROOT" -0 -r "$ROOTFS" -b /proc -b /dev /usr/bin/python3 --version 2>&1

log "== proot: node --version =="
"$PROOT" -0 -r "$ROOTFS" -b /proc -b /dev /usr/bin/node --version 2>&1

log "== proot: seaf-server -h =="
"$PROOT" -0 -r "$ROOTFS" -b /proc -b /dev -w / \
  /opt/seatable/seatable-server-latest/seafile/bin/seaf-server -h 2>&1 | head -5

log "DONE"
