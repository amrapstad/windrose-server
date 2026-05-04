FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Add i386 architecture
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
    software-properties-common \
    wget curl ca-certificates \
    gnupg2 git lib32gcc-s1 \
    && rm -rf /var/lib/apt/lists/*

# Add WineHQ repo and install Wine
RUN mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ \
    https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && \
    apt-get update && apt-get install -y --install-recommends winehq-stable \
    && rm -rf /var/lib/apt/lists/*

# Install SteamCMD directly (no repo needed)
RUN mkdir -p /opt/steamcmd && \
    curl -fsSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    | tar -xz -C /opt/steamcmd && \
    ln -s /opt/steamcmd/steamcmd.sh /usr/local/bin/steamcmd

# Create non-root user
RUN useradd -m windrose
USER windrose
WORKDIR /home/windrose

# Download Windrose server via SteamCMD
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