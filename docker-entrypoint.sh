#!/bin/sh
set -e

# preload data
if [ -d /test_data.d -a ! -f /data/dump.rdb ]; then
  echo "Loading test data..."
  redis-server - <<EOF
bind 127.0.0.1
daemonize yes
EOF

  sleep 1
  for file in /test_data.d/*; do
    echo "... processing: $file"
    redis-cli < "$file" >/dev/null
  done
  echo "... done.  Continuing startup."
  redis-cli save >/dev/null
  redis-cli shutdown >/dev/null
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

