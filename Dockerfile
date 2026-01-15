FROM alpine:3.20

# Installeer benodigde database clients
RUN apk add --no-cache mariadb-client postgresql16-client redis

# Create app directory
RUN mkdir -p /app

# Voeg het backup script en entrypoint toe
COPY backup.sh /app/backup.sh
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/backup.sh /app/entrypoint.sh

# Start het entrypoint script bij het runnen van de container
ENTRYPOINT ["/app/entrypoint.sh"]
