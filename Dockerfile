FROM alpine:3.18

# Installeer benodigde database clients
RUN apk add --no-cache mariadb-client postgresql16-client redis

# Voeg het backup script en entrypoint toe
COPY backup.sh /backup.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /backup.sh /entrypoint.sh

# Start het entrypoint script bij het runnen van de container
ENTRYPOINT ["/entrypoint.sh"]
