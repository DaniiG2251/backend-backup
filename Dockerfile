FROM alpine:3.18

RUN apk add --no-cache \
    mariadb-client \
    postgresql-client \
    redis \
    bash \
    curl

COPY backup.sh /backup.sh

RUN chmod +x /backup.sh

CMD ["/backup.sh"]