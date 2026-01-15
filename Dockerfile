FROM alpine:3.18

RUN apk add --no-cache \
    mysql-client \
    postgresql-client \
    redis \
    bash \
    curl

WORKDIR /app
COPY backup.sh /app/backup.sh

RUN chmod +x /app/backup.sh

CMD ["/app/backup.sh"]