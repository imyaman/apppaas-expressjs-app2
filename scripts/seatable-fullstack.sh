#!/bin/bash
# Runs UNDER proot (fake-root inside the seatable rootfs). Starts the FULL
# SeaTable stack directly (no my_init/runit, no pkill/killall — proot has no PID
# isolation so those are unsafe). Env (DB/redis/JWT/hostname/admin) is inherited.
log(){ echo "[seatable $(date +%T)] $*"; }
SL=/opt/seatable/seatable-server-latest

# ---- dirs + /opt/seatable/* -> /shared/seatable/* symlinks ----
for d in ccnet conf db-data logs pids seafile-data seahub-data storage-data; do
  mkdir -p /shared/seatable/$d; ln -sfn /shared/seatable/$d /opt/seatable/$d
done
mkdir -p /opt/nginx-logs /var/run /run
# clear stale pid/socket from a previous run (fresh deploy won't have these)
rm -f /var/run/*.pid /var/run/seafile.sock 2>/dev/null
# avatars
if [ ! -e /shared/seatable/seahub-data/avatars ]; then
  mkdir -p /shared/seatable/seahub-data/avatars
  cp -r $SL/dtable-web/media/avatars/* /shared/seatable/seahub-data/avatars/ 2>/dev/null
fi
rm -rf $SL/dtable-web/media/avatars
ln -sfn /shared/seatable/seahub-data/avatars $SL/dtable-web/media

# ---- set_env ----
export SRC_DIR=$SL
export LD_LIBRARY_PATH=$SL/seafile/lib/:/usr/lib/x86_64-linux-gnu/nss
export PYTHONPATH=$SL/dtable-web/thirdpart:$SL/seafile/lib/python3/site-packages:$SL/dtable-events
export PATH=$SL/seafile/bin/:$SL/dtable-web/thirdpart/bin:$PATH
export CCNET_CONF_DIR=/opt/seatable/ccnet SEAFILE_CONF_DIR=/opt/seatable/seafile-data SEAFILE_CENTRAL_CONF_DIR=/opt/seatable/conf
export SEAFILE_RPC_PIPE_PATH=/var/run DTABLE_SERVER_CONFIG=/opt/seatable/conf/dtable_server_config.json
export SEAHUB_LOG_DIR=/opt/seatable/logs LOG_DIR=/opt/seatable/logs DTABLE_WEB_DIR=$SL/dtable-web HOME=/root
export ENABLE_GO_FILESERVER=true SITE_ROOT=/ CACHE_PROVIDER=redis
export SEAFILE_MYSQL_DB_HOST=$SEATABLE_MYSQL_DB_HOST SEAFILE_MYSQL_DB_PORT=$SEATABLE_MYSQL_DB_PORT
export SEAFILE_MYSQL_DB_USER=$SEATABLE_MYSQL_DB_USER SEAFILE_MYSQL_DB_PASSWORD=$SEATABLE_MYSQL_DB_PASSWORD
export SEAFILE_MYSQL_DB_SEAFILE_DB_NAME=$SEATABLE_MYSQL_DB_SEAFILE_DB_NAME
export SEAFILE_MYSQL_DB_CCNET_DB_NAME=$SEATABLE_MYSQL_DB_CCNET_DB_NAME
export SEAFILE_MYSQL_DB_DTABLE_DB_NAME=$SEATABLE_MYSQL_DB_DTABLE_DB_NAME

# ---- conf (init_config) ----
if [ ! -f /opt/seatable/conf/gunicorn.py ]; then
  log "init_config"; python3 /templates/init_config.py 2>&1 | tail -3
fi

# ---- nginx: listen 80 -> 8080, link, start ----
sed -i 's/listen 80;/listen 8080;/; s/listen \[::\]:80;/listen [::]:8080;/' /opt/seatable/conf/nginx.conf
ln -sfn /opt/seatable/conf/nginx.conf /etc/nginx/sites-enabled/default
# /etc/nginx/nginx.conf already has 'daemon off;', so just background it.
nginx &>>/opt/seatable/logs/nginx.out &
sleep 1; log "nginx started (8080)"

# ---- seaf-server (integrated fileserver :8082) ----
log "seaf-server"
seaf-server -F /opt/seatable/conf -d /opt/seatable/seafile-data -l /opt/seatable/logs/seafile.log -P /var/run/seafile.pid -p /var/run - &
for i in $(seq 1 60); do [ -S /var/run/seafile.sock ] && break; sleep 0.2; done
log "socket: $(ls -l /var/run/seafile.sock 2>&1)"

# ---- plugins repo (needs seaf-server RPC + DB ready; retry) ----
if ! grep -qE "PLUGINS_REPO_ID *= *'[0-9a-f]" /opt/seatable/conf/dtable_web_settings.py 2>/dev/null; then
  sed -i "/PLUGINS_REPO_ID/d" /opt/seatable/conf/dtable_web_settings.py 2>/dev/null
  rid=""
  for i in $(seq 1 30); do
    rid=$(python3 -c "from seaserv import seafile_api; print(seafile_api.create_repo('plugins repo','plugins repo','dtable@seafile'))" 2>/dev/null)
    case "$rid" in ????????-*) break;; esac
    sleep 1
  done
  log "PLUGINS_REPO_ID=$rid"
  echo "PLUGINS_REPO_ID='$rid'" >> /opt/seatable/conf/dtable_web_settings.py
fi

# ---- app components ----
cd $SL/dtable-events/dtable_events && python3 main.py --config-file /opt/seatable/conf/dtable-events.conf --logfile /opt/seatable/logs/dtable-events.log &>>/opt/seatable/logs/dtable-events.log &
sleep 1
# gunicorn daemon=True double-forks (unreliable under proot) + hides errors; run foreground+log
sed -i 's/^daemon = True/daemon = False/' /opt/seatable/conf/gunicorn.py
cd $SL/dtable-web && gunicorn seahub.wsgi:application -c /opt/seatable/conf/gunicorn.py &>>/opt/seatable/logs/gunicorn.log &
sleep 0.3
cd $SL/dtable-storage-server && ./dtable-storage-server -c /opt/seatable/conf/dtable-storage-server.conf & echo $! >/var/run/dtable-storage-server.pid
sleep 0.3
cd $SL/dtable-server && node dist/src/index.js &>>/opt/seatable/logs/dtable-server.log &
sleep 0.3
cd $SL/dtable-db && ./dtable-db -c /opt/seatable/conf/dtable-db.conf & echo $! >/var/run/dtable-db.pid
sleep 0.3
cd $SL/dtable-db && { [ -e /opt/seatable/conf/dtable-api-gateway.conf ] && ./api-gateway -c /opt/seatable/conf/dtable-api-gateway.conf || ./api-gateway; } & echo $! >/var/run/api-gateway.pid
log "components started"

# ---- superuser (idempotent; admin may already exist in apppaas_app1) ----
bash /templates/seatable.sh auto-create-superuser x &>>/opt/seatable/logs/init.log &

log "READY (nginx :8080)"
# keep foreground
exec tail -F /opt/seatable/logs/dtable_web.log 2>/dev/null
