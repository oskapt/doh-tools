# Docker-delivered DOH Proxy

DNS over HTTPS. Cool, right? You can run this and funnel all your DNS requests over HTTPS, and then no one can snoop on them.

How do you get that protection for your whole computer? It's not enough to only protect requests from Firefox or Vivaldi.

Enter [DoH Proxy](https://facebookexperimental.github.io/doh-proxy/), a set of tools that run under Python and enable:

* Client - used for testing DoH servers
* Server - used to translate DoH requests to DNS requests
* HTTP Server - same as Server, but used behind a reverse proxy that does SSL offloading
* Stub - translate DNS requests to DoH requests

But what if you don't want to install these onto your local system? What if, for example, your local system runs Python 3.7, and the DoH tool suite doesn't build because of a [bug in aioh2](https://github.com/facebookexperimental/doh-proxy/issues/63)?

Well, that's why we have Docker.

This bundles the DOH Proxy tool suite with Python 3.5 and an entrypoint that allows you to alias them on your computer and run them as direct commands:

```bash
# fish
function doh-client
  docker run --rm -it monachus/doh-tools client $argv
end
```

```bash
# bash
function doh-client() {
    docker run --rm -it monachus/doh-tools client "$@"
}
```

With either of these you can run a command like:

```bash
$ doh-client --domain 1.1.1.1 --qtype a --qname monach.us

2019-10-08 01:38:27,431:    DEBUG: Opening connection to 1.1.1.1
2019-10-08 01:38:27,538:    DEBUG: Query parameters: {'dns': 'AAABAAABAAAAAAAABm1vbmFjaAJ1cwAAAQAB'}
2019-10-08 01:38:27,539:    DEBUG: Stream ID: 1 / Total streams: 0
2019-10-08 01:38:27,628:    DEBUG: Response headers: [(':status', '200'), ('date', 'Tue, 08 Oct 2019 01:38:27 GMT'), ('content-type', 'application/dns-message'), ('content-length', '128'), ('access-control-allow-origin', '*'), ('cache-control', 'max-age=7200'), ('expect-ct', 'max-age=604800, report-uri="https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct"'), ('server', 'cloudflare'), ('cf-ray', '5224653a598ccfb3-SCL')]
id 0
opcode QUERY
rcode NOERROR
flags QR RD RA
edns 0
payload 1452
option Generic 12
;QUESTION
monach.us. IN A
;ANSWER
monach.us. 7200 IN A 159.89.221.68
;AUTHORITY
;ADDITIONAL
2019-10-08 01:38:27,631:    DEBUG: Response trailers: {}
```

## Usage

```bash
$ docker run --rm -it monachus/doh-tools:develop
Usage: doh-tools {client|server|stub|http-proxy} [options]
```

## Certificates

If you're running DoH queries against something signed by an unknown CA, you can put the CA certificate in `certs` and rebuild the container. The certificate will be built into the CA certificates store. If the file is named `myca.pem` then it will be built into the store as `ca-cert-myca.pem`. You can then use this with `--cafile /etc/ssl/certs/ca-cert-myca.pem` when running `doh-tools client`.

If you plan to use this as a server, you'll hopefully be using an orchestrator like Kubernetes. Mount your key and cert into the container securely at runtime and then pass `--certfile` and `--keyfile` to `doh-tools server`.

## Testing

There's a rudimentary `test.sh` script that will build the container and make sure that each of the options correctly returns something and a 0 exit code.
