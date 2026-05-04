#!/bin/bash

SERVER_DIR="/home/windrose/windrose_server"
SAVE_DIR="$SERVER_DIR/R5/Saved/SaveProfiles/Default/RocksDB"

echo "Checking for Windrose server updates..."
/opt/steamcmd/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir "$SERVER_DIR" \
    +login anonymous \
    +app_update 4129620 \
    +quit || echo "SteamCMD failed, continuing anyway..."

echo "Copying world save..."
mkdir -p "$SAVE_DIR"
cp -r /saves/. "$SAVE_DIR/" || echo "Save copy failed, continuing anyway..."

echo "Initializing Wine..."
wineboot --init || echo "Wineboot failed, continuing anyway..."

echo "Starting Windrose server..."
wine "$SERVER_DIR/WindroseServer.exe"