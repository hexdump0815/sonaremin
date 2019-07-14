#!/bin/bash

# read the sonaremin config file if it exists, otherwise set default values
if [ -f /data/config/sonaremin.txt ]; then
  . /data/config/sonaremin.txt
else
  # start synthv1 automatically
  #SYNTHV1_START=yes
  SYNTHV1_START=no
  # start qjackctl automatically
  QJACKCTL_START=yes
  #QJACKCTL_START=no
fi

if [ -f /data/config/info.txt ]; then
  . /data/config/info.txt
fi
MYARCH=`uname -m`
# synthv1 needs to use mesa, otherwise it will segfault on the 32bit rpi
if [ "$SYSTEM_MODEL" = "raspberrypi" ] && [ "$MYARCH" = "armv7l" ]; then
  export LD_LIBRARY_PATH=/opt/libgl
fi

SYNTHV1_01_PID=`pidof /opt/synthv1-s01/bin/synthv1_jack`
if { [ "$QJACKCTL_START" = "yes" ] && [ "$SYNTHV1_START" = "yes" ] && [ "$SYNTHV1_01_PID" = "" ]; } \
    || { [ "$1" = "menu" ] && [ "$SYNTHV1_01_PID" = "" ]; }; then
  ( cd /data/synthv1 ; cp sonaremin-01.conf backup/sonaremin-01.conf; /opt/synthv1-s01/bin/synthv1_jack sonaremin-01.synthv1-s01 ) &
  sleep 2
fi
SYNTHV1_02_PID=`pidof /opt/synthv1-s02/bin/synthv1_jack`
if { [ "$QJACKCTL_START" = "yes" ] && [ "$SYNTHV1_START" = "yes" ] && [ "$SYNTHV1_02_PID" = "" ]; } \
    || { [ "$1" = "menu" ] && [ "$SYNTHV1_02_PID" = "" ]; }; then
  ( cd /data/synthv1 ; cp sonaremin-02.conf backup/sonaremin-02.conf; /opt/synthv1-s02/bin/synthv1_jack sonaremin-02.synthv1-s02 ) &
fi
