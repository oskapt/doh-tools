#!/bin/ash

MODE=$1
shift

function usage() {
  echo "Usage: doh-tools {client|server|stub|http-proxy} [options]"
  echo
  echo "client: used for testing DOH servers"
  echo "server: a DOH server - requires volume and certificate management"
  echo "http-proxy: a non-TLS DOH server for use behind a reverse proxy"
  echo "stub: a local server that will answer DNS queries and forward them over DOH"

  exit 0
}


if [[ -z ${MODE} || "${MODE:0:1}" = '-' ]]; then
  usage
fi

case $MODE in
  client) exec /usr/local/bin/doh-client "$@";;
  proxy|server) exec /usr/local/bin/doh-proxy "$@";;
  stub) exec /usr/local/bin/doh-stub "$@";;
  http-proxy) exec /usr/local/bin/doh-httpproxy "$@";;
esac

exec "${MODE}"