#!/bin/bash
set -e

DB_PATH="/app/db/production.sqlite3"
BACKUP_REPO="/app/history-database"
OUT_PATH="$BACKUP_REPO/events.csv"

echo "Backing up events table to CSV..."

sqlite3 "$DB_PATH" <<!
.headers on
.mode csv
.output $OUT_PATH
SELECT * FROM events;
!

cd "$BACKUP_REPO"
git add events.csv
git commit -m "Weekly backup: $(date +%Y-%m-%d)"
git push

echo "Backup complete: $OUT_PATH"
