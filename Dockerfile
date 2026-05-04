FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
    software-properties-common \
    lib32gcc-s1 \
    wget curl ca-certificates \
    winbind wine wine32 wine64 \
    steamcmd git \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m windrose
USER windrose
WORKDIR /home/windrose

# Download Windrose server files
RUN steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /home/windrose/windrose_server \
    +login anonymous \
    +app_update 4129620 validate \
    +quit

# Copy startup script
COPY --chown=windrose:windrose scripts/start.sh /home/windrose/start.sh
RUN chmod +x /home/windrose/start.sh

CMD ["/home/windrose/start.sh"]