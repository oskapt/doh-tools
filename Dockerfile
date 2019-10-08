FROM python:3.5-alpine

WORKDIR /usr/src/app
RUN pip install --no-cache-dir doh-proxy

COPY entrypoint.sh /
COPY certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates && \
    chmod 700 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]