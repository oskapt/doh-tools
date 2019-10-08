#!/bin/bash

docker build -t doh-tools-test . || exit $?

# test with client
docker run --rm -it doh-tools-test client --help | head -n 1  | /usr/bin/grep doh-client || exit $?

# test with proxy
docker run --rm -it doh-tools-test proxy --help | head -n 1  | /usr/bin/grep doh-proxy || exit $?

# test with server
docker run --rm -it doh-tools-test server --help | head -n 1  | /usr/bin/grep doh-proxy || exit $?

# test with http-proxy
docker run --rm -it doh-tools-test http-proxy --help | head -n 1  | /usr/bin/grep doh-httpproxy || exit $?

# test with stub
docker run --rm -it doh-tools-test stub --help | head -n 1  | /usr/bin/grep doh-stub || exit $?

# test with --help
docker run --rm -it doh-tools-test --help | head -n 1  | /usr/bin/grep doh-client || exit $?

# test with no command
docker run --rm -it doh-tools-test | head -n 1  | /usr/bin/grep doh-client || exit $?

docker rmi doh-tools-test