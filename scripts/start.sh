#!/bin/bash

export WINEPREFIX=/root/.wine
export WINEARCH=win64
export DISPLAY=:0
SERVER_DIR="/home/windrose/windrose_server"
SAVE_DIR="$SERVER_DIR/R5/Saved/SaveProfiles/Default/RocksDB"

echo "Starting virtual display..."
Xvfb :0 -screen 0 1024x768x16 &
sleep 2

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