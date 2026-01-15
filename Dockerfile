FROM alpine:3.18

# Installeer benodigde database clients
RUN apk add --no-cache mariadb-client postgresql16-client redis

# Voeg het backup script toe
COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

# Start het backup script bij het runnen van de container
ENTRYPOINT ["/backup.sh"]
