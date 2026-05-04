FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEPREFIX=/root/.wine
ENV WINEARCH=win64
ENV DISPLAY=:0

RUN dpkg --add-architecture i386 && \
    for i in 1 2 3; do apt-get update && break || sleep 10; done && \
    apt-get install -y --fix-missing \
    software-properties-common \
    wget curl ca-certificates \
    gnupg2 git lib32gcc-s1 \
    xvfb \
    libvulkan1 libvulkan1:i386 \
    mesa-vulkan-drivers mesa-vulkan-drivers:i386 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ \
    https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && \
    for i in 1 2 3; do apt-get update && break || sleep 10; done && \
    apt-get install -y --fix-missing --install-recommends winehq-stable \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/steamcmd && \
    curl -fsSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    | tar -xz -C /opt/steamcmd && \
    chmod -R 755 /opt/steamcmd && \
    ln -s /opt/steamcmd/steamcmd.sh /usr/local/bin/steamcmd

RUN useradd -m windrose

RUN mkdir -p /home/windrose/windrose_server && \
    chown -R windrose:windrose /home/windrose/windrose_server

USER root
WORKDIR /home/windrose

COPY --chown=root:root scripts/start.sh /home/windrose/start.sh
RUN chmod +x /home/windrose/start.sh

CMD ["/home/windrose/start.sh"]