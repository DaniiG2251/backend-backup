# Docker Backup Container

Een lichte Docker container om automatische backups te maken van MariaDB, PostgreSQL en Redis.

## Features

✅ Geautomatiseerde backups van MariaDB, PostgreSQL en Redis  
✅ Gzip compressie voor ruimtebesparing  
✅ Automatische cleanup van oude backups  
✅ Logging naar bestand voor monitoring  
✅ Error handling en status updates  
✅ Alpine Linux (klein & snel)  

## Vereisten

- Docker & Docker Compose
- Draaiende MariaDB, PostgreSQL en/of Redis containers
- Shared Docker network (`backend`)
- Map voor backups (bijv. `/srv/backups`)

## Installatie

1. Clone deze repository:
   ```bash
   git clone https://github.com/DaniiG2251/backend-backup.git
   cd backend-backup
   ```

2. Kopieer `.env.example` naar `.env` en vul je credentials in:
   ```bash
   cp .env.example .env
   ```

3. Bouw de container:
   ```bash
   docker-compose build
   ```

## Gebruik

### Manual backup
```bash
docker-compose run --rm backup
```

### Automatische backups (cron job)

Voeg dit toe aan je crontab (dagelijks om 02:00):
```bash
crontab -e
```

Voeg deze regel toe:
```bash
0 2 * * * cd /pad/naar/backend-backup && /usr/bin/docker-compose run --rm backup >> /var/log/backup.log 2>&1
```

## Configuratie

Pas de `.env` bestand aan:

```env
MARIADB_HOST=mariadb        # Hostnaam van je MariaDB container
MARIADB_USER=root           # Database user
MARIADB_PASSWORD=...        # Database password

POSTGRES_HOST=postgresql    # Hostnaam van je PostgreSQL container
POSTGRES_USER=postgres      # Database user
POSTGRES_PASSWORD=...       # Database password

REDIS_HOST=redis            # Hostnaam van je Redis container

BACKUP_DIR=/srv/backups     # Map waar backups worden opgeslagen
RETENTION_DAYS=7            # Hoe lang backups bewaard worden (dagen)
```

## Backup bestanden

Backups worden opgeslagen in de volgende indeling:
- `mariadb_backup_YYYY-MM-DD_HH-MM-SS.sql.gz`
- `postgresql_backup_YYYY-MM-DD_HH-MM-SS.sql.gz`
- `redis_dump_YYYY-MM-DD_HH-MM-SS.rdb`
- `backup_YYYY-MM-DD_HH-MM-SS.log` (logbestand)

## Troubleshooting

### "Connection refused" fouten
- Zorg dat je Docker network `backend` bestaat: `docker network create backend`
- Controleer dat alle containers in hetzelfde network staan
- Test verbinding: `docker exec -it backup ping mariadb`

### Redis backup faalt
- Zorg dat Redis volume `/data` bereikbaar is
- Check Redis permissions: `docker exec redis redis-cli PING`

### Backups groeien te snel
- Verhoog `RETENTION_DAYS` in `.env` of verlaag het
- Controleer met: `du -sh /srv/backups`

## Logs controleren

```bash
# Laatste backup logs
tail -f /srv/backups/backup_*.log

# Via Docker
docker logs backend-backup
```

## Best Practices

1. **Test je backups** - Maak regelmatig test restores
2. **Externe opslag** - Backup je `/srv/backups` map extern (S3, cloud, etc.)
3. **Monitoring** - Controleer logbestanden op fouten
4. **Redundantie** - Houd meerdere backup versies
5. **Encryptie** - Versleutel backups voor gevoelige data

## Licentie

MIT

## Support

Vragen of problemen? Check de logbestanden of open een issue.