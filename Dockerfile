FROM redis:7.0.14-alpine
LABEL uk.co.oozlum.version="1.0"
LABEL uk.co.oozlum.description="Redis preloaded data container"

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
