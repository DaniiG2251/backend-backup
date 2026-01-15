FROM alpine:3.20

# Installeer benodigde database clients en dos2unix voor line-ending conversie
RUN apk add --no-cache mariadb-client postgresql16-client redis dos2unix

# Create app directory
RUN mkdir -p /app

# Voeg het backup script en entrypoint toe
COPY backup.sh /app/
COPY entrypoint.sh /app/

# Converteer line endings naar UNIX format en maak scripts executable
RUN dos2unix -k /app/backup.sh /app/entrypoint.sh && \
    chmod +x /app/backup.sh /app/entrypoint.sh

# Start het entrypoint script bij het runnen van de container
ENTRYPOINT ["/app/entrypoint.sh"]
