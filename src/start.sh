#!/usr/bin/bash

# By default docker gives us 64MB of shared memory size but to display heavy
# pages we need more.
umount /dev/shm && mount -t tmpfs shm /dev/shm
rm /tmp/.X0-lock &>/dev/null || true

sed -i -e 's/console/anybody/g' /etc/X11/Xwrapper.config
echo "needs_root_rights=yes" >> /etc/X11/Xwrapper.config
dpkg-reconfigure xserver-xorg-legacy

# create start script for X11
echo "#!/bin/bash" > /usr/app/src/xstart.sh
echo "xset s off -dpms" >> /usr/app/src/xstart.sh
echo "chromium-browser --kiosk $URL --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage" >> /usr/app/src/xstart.sh

chmod 770 /usr/app/src/xstart.sh
chown service:service /usr/app/src/xstart.sh

if which udevadm > /dev/null; then
    set +e # Disable exit on error 
    udevadm control --reload-rules service udev restart udevadm trigger set -e # Re-enable exit on error
fi

# starting chromium as service user
su -c 'startx /home/chromium/xstart.sh' service