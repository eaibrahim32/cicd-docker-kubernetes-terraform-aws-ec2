#!/bin/bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups"
mkdir -p $BACKUP_DIR
echo "Starting backup..."
docker exec $(docker-compose ps -q db) mysqldump -u root -ppassword appdb > "$BACKUP_DIR/appdb_$TIMESTAMP.sql"
echo "Backup saved to $BACKUP_DIR/appdb_$TIMESTAMP.sql"
