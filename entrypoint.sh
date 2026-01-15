#!/bin/bash

set -euo pipefail

# Default interval is 1440 minutes (24 hours / daily)
BACKUP_INTERVAL_MINUTES=${BACKUP_INTERVAL_MINUTES:-1440}

# Convert minutes to seconds once
SLEEP_SECONDS=$((BACKUP_INTERVAL_MINUTES * 60))

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup container gestart"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup interval: ${BACKUP_INTERVAL_MINUTES} minuten"

# Infinite loop to run backups at the specified interval
while true; do
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup wordt uitgevoerd..."
    
    # Execute the backup script with error handling
    if /backup.sh; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup succesvol voltooid. Volgende backup over ${BACKUP_INTERVAL_MINUTES} minuten..."
    else
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✗ Backup gefaald (exit code: $?). Volgende poging over ${BACKUP_INTERVAL_MINUTES} minuten..."
    fi
    
    sleep "$SLEEP_SECONDS"
done
