#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
SAVE_SRC="/var/lib/docker/volumes/windrose_saves/_data"
REPO_DIR="/opt/windrose-server"
BACKUP_DIR="$REPO_DIR/saves"
GIT_EMAIL="your@email.com"
GIT_NAME="Windrose Backup Bot"

echo "[$TIMESTAMP] Starting backup..."

# Stop server gracefully
docker stop windrose

# Copy saves into repo
cp -r "$SAVE_SRC"/. "$BACKUP_DIR/"

# Git commit and push
cd "$REPO_DIR"
git config user.email "$GIT_EMAIL"
git config user.name "$GIT_NAME"
git add saves/
git commit -m "Auto backup - $TIMESTAMP"
git push

# Restart server
docker start windrose

echo "[$TIMESTAMP] Backup complete!"