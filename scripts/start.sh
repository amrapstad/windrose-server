#!/bin/bash

SERVER_DIR="/home/windrose/windrose_server"
SAVE_DIR="$SERVER_DIR/R5/Saved/SaveProfiles/Default/RocksDB"

# Only download server files if not already present
if [ ! -f "$SERVER_DIR/WindroseServer.exe" ]; then
    echo "Downloading Windrose server files..."
    /opt/steamcmd/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir "$SERVER_DIR" \
        +login anonymous \
        +app_update 4129620 validate \
        +quit
else
    echo "Server files already present, skipping download."
fi

# Copy world save
echo "Copying world save..."
mkdir -p "$SAVE_DIR"
cp -r /saves/. "$SAVE_DIR/"

# Init Wine
echo "Initializing Wine..."
wineboot --init

# Start server
echo "Starting Windrose server..."
wine "$SERVER_DIR/WindroseServer.exe"