#!/bin/bash

set -euo pipefail

BACKUP_DIR=${BACKUP_DIR:-/backups}
RETENTION_DAYS=${RETENTION_DAYS:-7}
mkdir -p "$BACKUP_DIR"

# Create dedicated subdirectories
mkdir -p "$BACKUP_DIR/mariadb"
mkdir -p "$BACKUP_DIR/postgresql"
mkdir -p "$BACKUP_DIR/redis"
mkdir -p "$BACKUP_DIR/log"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$BACKUP_DIR/log/backup_$TIMESTAMP.log"

# Logging functie
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== Backup gestart ==="

# MariaDB backup
if [ -n "${MARIADB_HOST:-}" ]; then
    log "MariaDB aan het backuppen..."
    if mysqldump \
        -h "$MARIADB_HOST" \
        -u "$MARIADB_USER" \
        -p"$MARIADB_PASSWORD" \
        --all-databases \
        --single-transaction \
        --quick | gzip > "$BACKUP_DIR/mariadb/mariadb_backup_$TIMESTAMP.sql.gz"; then
        log "✓ MariaDB backup succesvol"
    else
        log "✗ MariaDB backup faalde"
        exit 1
    fi
fi

# PostgreSQL backup
if [ -n "${POSTGRES_HOST:-}" ]; then
    log "PostgreSQL aan het backuppen..."
    if PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall \
        -h "$POSTGRES_HOST" \
        -U "$POSTGRES_USER" \
        | gzip > "$BACKUP_DIR/postgresql/postgresql_backup_$TIMESTAMP.sql.gz"; then
        log "✓ PostgreSQL backup succesvol"
    else
        log "✗ PostgreSQL backup faalde"
        exit 1
    fi
fi

# Redis backup
if [ -n "${REDIS_HOST:-}" ]; then
    log "Redis aan het backuppen..."
    if redis-cli -h "$REDIS_HOST" BGSAVE > /dev/null 2>&1; then
        sleep 2
        if cp /data/dump.rdb "$BACKUP_DIR/redis/redis_dump_$TIMESTAMP.rdb"; then
            log "✓ Redis backup succesvol"
        else
            log "✗ Redis dump.rdb copy faalde"
            exit 1
        fi
    else
        log "✗ Redis BGSAVE faalde"
        exit 1
    fi
fi

# Cleanup oude backups
log "Oude backups aan het verwijderen (ouder dan $RETENTION_DAYS dagen)..."
for subdir in mariadb postgresql redis log; do
    find "$BACKUP_DIR/$subdir" -type f -mtime +"$RETENTION_DAYS" -delete 2>/dev/null || true
done

log "=== Backup compleet ==="
log "Backup bestanden:"
for subdir in mariadb postgresql redis log; do
    if [ -d "$BACKUP_DIR/$subdir" ] && [ "$(ls -A "$BACKUP_DIR/$subdir" 2>/dev/null)" ]; then
        echo "  $subdir/:" >> "$LOG_FILE"
        ls -lh "$BACKUP_DIR/$subdir" | tail -n +2 | sed 's/^/    /' >> "$LOG_FILE"
    fi
done