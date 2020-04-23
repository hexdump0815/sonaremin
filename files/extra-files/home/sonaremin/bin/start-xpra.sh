#!/bin/bash

# read the actual config info file if it exists
if [ -f /data/config/info.txt ]; then
  . /data/config/info.txt
fi

# bypass the accelerated opengl here for xrpa as it is safer this way
if [ -d /usr/lib/arm-linux-gnueabihf ]; then
  export LD_LIBRARY_PATH=/usr/lib/arm-linux-gnueabihf
elif [ -d /usr/lib/aarch64-linux-gnu ]; then
  export LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu
fi

cd /home/sonaremin

if [ "$SYSTEM_MODEL" = "raspberrypi" ]; then
  # for the mesa case we use xorgxrdp instead of xvfb for xpra to get gpu acceleration
  xpra start-desktop :100 --start-child=startfluxbox --exit-with-children --xvfb="Xorg :10 vt7 -auth .Xauthority -config xrdp/xorg.conf -noreset -nolisten tcp" --start-via-proxy=no --systemd-run=no --file-transfer=no --printing=no --resize-display=no --mdns=no --pulseaudio=no --dbus-proxy=no --dbus-control=no --webcam=no --notifications=no > /tmp/start-xpra.log 2>&1
else
  # for everything else we stick to xvfb
  xpra start-desktop :100 --start-child=startfluxbox --exit-with-children --xvfb="Xvfb -nolisten tcp -noreset +extension GLX +extension Composite -auth \$XAUTHORITY -screen 0 1024x768x24" --start-via-proxy=no --systemd-run=no --file-transfer=no --printing=no --resize-display=no --mdns=no --pulseaudio=no --dbus-proxy=no --dbus-control=no --webcam=no --notifications=no > /tmp/start-xpra.log 2>&1
fi
