#!/bin/bash
# Populate ./seafile-native/ with seaf-server binaries + libraries extracted
# from the SeaTable developer image, plus libsasl2 (needed on hosts lacking it).
# Requires podman and the image on this host.
set -e
IMAGE="${SEATABLE_IMAGE:-docker.io/seatable/seatable-developer:6.1.0}"
DEST="$(cd "$(dirname "$0")" && pwd)/seafile-native"

echo "Extracting seafile runtime from $IMAGE -> $DEST"
CID=$(sudo podman create "$IMAGE")
trap 'sudo podman rm "$CID" >/dev/null 2>&1 || true' EXIT

rm -rf "$DEST"
sudo podman cp "$CID:/opt/seatable/seatable-server-latest/seafile" "$DEST"

# libsasl2 (image path is a symlink -> the real .so); copy real file + SONAME link
REAL=$(sudo podman run --rm --entrypoint sh "$IMAGE" -c 'readlink -f /lib/x86_64-linux-gnu/libsasl2.so.2')
sudo podman cp "$CID:$REAL" "$DEST/lib/"
ln -sf "$(basename "$REAL")" "$DEST/lib/libsasl2.so.2"

# glibc loader + core libs, so the glibc binary can run on a musl host (Alpine)
# via: ld-linux ... --library-path lib:glibc seaf-server  (auto-used by lib/seafServer.js)
GLIBC="$DEST/glibc"; mkdir -p "$GLIBC"
for f in /lib64/ld-linux-x86-64.so.2 \
         /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libm.so.6 \
         /lib/x86_64-linux-gnu/libresolv.so.2 /lib/x86_64-linux-gnu/libpthread.so.0 \
         /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu/librt.so.1 \
         /lib/x86_64-linux-gnu/libnss_files.so.2 /lib/x86_64-linux-gnu/libnss_dns.so.2; do
  R=$(sudo podman run --rm --entrypoint sh "$IMAGE" -c "readlink -f $f" 2>/dev/null) || continue
  sudo podman cp "$CID:$R" "$GLIBC/" 2>/dev/null || continue
  [ "$(basename "$f")" != "$(basename "$R")" ] && ln -sf "$(basename "$R")" "$GLIBC/$(basename "$f")"
done

sudo chown -R "$USER:$USER" "$DEST" 2>/dev/null || true
echo "Done. $(du -sh "$DEST" | cut -f1) in $DEST"
