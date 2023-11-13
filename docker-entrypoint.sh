#!/bin/sh
set -e

# preload data
preload() {
  AOF=no
  if [ -f /redis.aof ]; then
    echo "AOF file detected... "
    cp /redis.aof /data/appendonly.aof
    AOF=yes
  elif [ -f /redis.rdb ]; then
    echo "RDB file detected... "
    cp /redis.rdb /data/dump.rdb
  fi

  redis-server - <<EOF
bind 127.0.0.1
daemonize yes
appendonly ${AOF}
EOF
  sleep 1

  if [ -d /test_data.d ]; then
    for file in /test_data.d/*; do
      echo "... processing: $file"
      redis-cli < "$file" >/dev/null
    done
  fi

  echo "... done.  Continuing startup."
  redis-cli save >/dev/null
  redis-cli shutdown >/dev/null
}

if [ ! -f /data/dump.rdb ]; then
  echo "Loading test data..."
  preload
fi

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	find . \! -user redis -exec chown redis '{}' +
	exec su-exec redis "$0" "$@"
fi

exec "$@"

