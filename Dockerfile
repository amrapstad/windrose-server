FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Add i386 architecture
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
    software-properties-common \
    wget curl ca-certificates \
    gnupg2 \
    git \
    && rm -rf /var/lib/apt/lists/*

# Add WineHQ repo
RUN mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ \
    https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources

# Add SteamCMD repo
RUN curl -fsSL https://repo.steampowered.com/steam/archive/precise/steam.gpg \
    | gpg --dearmor -o /usr/share/keyrings/steam.gpg && \
    echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] \
    https://repo.steampowered.com/steam/archive/precise steam precise" \
    > /etc/apt/sources.list.d/steam.list

# Install Wine and SteamCMD
RUN apt-get update && apt-get install -y \
    --install-recommends winehq-stable \
    lib32gcc-s1 \
    steamcmd \
    && rm -rf /var/lib/apt/lists/*

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