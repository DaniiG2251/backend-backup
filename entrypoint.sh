#!/bin/bash

set -euo pipefail

# Default interval is 1440 minutes (24 hours / daily)
BACKUP_INTERVAL_MINUTES=${BACKUP_INTERVAL_MINUTES:-1440}

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup container gestart"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup interval: ${BACKUP_INTERVAL_MINUTES} minuten"

# Infinite loop to run backups at the specified interval
while true; do
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup wordt uitgevoerd..."
    
    # Execute the backup script
    /backup.sh
    
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Backup voltooid. Volgende backup over ${BACKUP_INTERVAL_MINUTES} minuten..."
    
    # Convert minutes to seconds and sleep
    SLEEP_SECONDS=$((BACKUP_INTERVAL_MINUTES * 60))
    sleep "$SLEEP_SECONDS"
done
