#!/bin/bash

cd /home/sonaremin
xpra start-desktop :100 --start-child=startfluxbox --exit-with-children --xvfb='Xvfb -nolisten tcp -noreset +extension GLX +extension Composite -auth $XAUTHORITY -screen 0 896x640x24' --start-via-proxy=no --systemd-run=no --file-transfer=no --printing=no --resize-display=no --mdns=no --pulseaudio=no --dbus-proxy=no --dbus-control=no --webcam=no --notifications=no > /tmp/start-xpra.log 2>&1
