#!/bin/bash

SAVE_DIR="/home/windrose/windrose_server/R5/Saved/SaveProfiles/Default/RocksDB"
REPO_SAVES="/saves"

echo "Copying world save from repo..."
mkdir -p "$SAVE_DIR"
cp -r "$REPO_SAVES"/. "$SAVE_DIR/"

echo "Starting Windrose server..."
wine /home/windrose/windrose_server/WindroseServer.exe