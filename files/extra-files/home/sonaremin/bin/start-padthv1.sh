#!/bin/bash

# read the sonaremin config file if it exists, otherwise set default values
if [ -f /data/config/sonaremin.txt ]; then
  . /data/config/sonaremin.txt
else
  # start padthv1 automatically
  #PADTHV1_START=yes
  PADTHV1_START=no
  # start qjackctl automatically
  QJACKCTL_START=yes
  #QJACKCTL_START=no
fi

if [ -f /data/config/info.txt ]; then
  . /data/config/info.txt
fi
MYARCH=`uname -m`
# padthv1 needs to use mesa, otherwise it will segfault on the 32bit rpi
if [ "$SYSTEM_MODEL" = "raspberrypi" ] && [ "$MYARCH" = "armv7l" ]; then
  export LD_LIBRARY_PATH=/opt/libgl
# otherwise bypass the accelerated opengl here as it is safer this way
else
  if [ -d /usr/lib/arm-linux-gnueabihf ]; then
    export LD_LIBRARY_PATH=/usr/lib/arm-linux-gnueabihf
  elif [ -d /usr/lib/aarch64-linux-gnu ]; then
    export LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu
  fi
fi

PADTHV1_01_PID=`pidof /opt/padthv1-s01/bin/padthv1_jack`
if { [ "$QJACKCTL_START" = "yes" ] && [ "$PADTHV1_START" = "yes" ] && [ "$PADTHV1_01_PID" = "" ]; } \
    || { [ "$1" = "menu" ] && [ "$PADTHV1_01_PID" = "" ]; }; then
  ( cd /data/padthv1 ; cp sonaremin-01.conf backup/sonaremin-01.conf; /opt/padthv1-s01/bin/padthv1_jack sonaremin-01.padthv1-s01 ) &
  sleep 2
fi
PADTHV1_02_PID=`pidof /opt/padthv1-s02/bin/padthv1_jack`
if { [ "$QJACKCTL_START" = "yes" ] && [ "$PADTHV1_START" = "yes" ] && [ "$PADTHV1_02_PID" = "" ]; } \
    || { [ "$1" = "menu" ] && [ "$PADTHV1_02_PID" = "" ]; }; then
  ( cd /data/padthv1 ; cp sonaremin-02.conf backup/sonaremin-02.conf; /opt/padthv1-s02/bin/padthv1_jack sonaremin-02.padthv1-s02 ) &
fi
