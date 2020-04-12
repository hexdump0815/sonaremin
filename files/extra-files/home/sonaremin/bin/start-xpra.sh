#!/bin/bash

# size of the virtual display for the virtual mode (horizontal x vertical pixels)
VIRTUAL_SIZE=896x640

# bypass the accelerated opengl here for xrpa as it is safer this way
if [ -d /usr/lib/arm-linux-gnueabihf ]; then
  export LD_LIBRARY_PATH=/usr/lib/arm-linux-gnueabihf
elif [ -d /usr/lib/aarch64-linux-gnu ]; then
  export LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu
fi

cd /home/sonaremin
xpra start-desktop :100 --start-child=startfluxbox --exit-with-children --xvfb="Xvfb -nolisten tcp -noreset +extension GLX +extension Composite -auth \$XAUTHORITY -screen 0 ${VIRTUAL_SIZE}x24" --start-via-proxy=no --systemd-run=no --file-transfer=no --printing=no --resize-display=no --mdns=no --pulseaudio=no --dbus-proxy=no --dbus-control=no --webcam=no --notifications=no > /tmp/start-xpra.log 2>&1
