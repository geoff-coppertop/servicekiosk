FROM coppertopgeoff/servicebase:edge

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
        apt-utils                   \
        curl                        \
        xserver-xorg-core           \
        xserver-xorg-legacy         \
        xserver-xorg-input-all      \
        xserver-xorg-video-fbdev    \
        x11-xserver-utils           \
        xorg                        \
        chromium-browser            \
        libxcb-image0               \
        xdg-utils                   \
        libdbus-1-dev               \
        libcap-dev                  \
        libxtst-dev                 \
        libxss1                     \
        lsb-release                 \
        fbset                       \
        libexpat-dev                \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=service:service ./src/start.sh /usr/app/src/start.sh

USER service

ENV URL='https://google.ca'
ENV INITSYSTEM='on'
ENV UDEV='on'