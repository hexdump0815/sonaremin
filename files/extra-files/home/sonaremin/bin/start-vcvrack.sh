#!/bin/bash

if [ -f /data/config/info.txt ]; then
  . /data/config/info.txt
  if [ "$LIBGL_FB" != "" ]; then
    export LIBGL_FB
  fi
else
  # extra addition in front of the LD_LIBRARY_PATH when starting vcvrack
  LDLP_PRE_EXTRA=""
fi

# read the sonaremin config file if it exists, otherwise set default values
if [ -f /data/config/sonaremin.txt ]; then
  . /data/config/sonaremin.txt
else
  # start with a hdmi monitor connected (display) or virtual
  DISPLAY_MODE=display
  #DISPLAY_MODE=virtual
  #DISPLAY_MODE=headless
  # start qjackctl automatically
  QJACKCTL_START=yes
  #QJACKCTL_START=no
  # start vcvrack automatically
  VCVRACK_START=yes
  #VCVRACK_START=no
  # which vcvrack version to start automativally
  VCVRACK_VERSION=v1
fi

VCVRACK_PID=`pidof Rack`
if { [ "$QJACKCTL_START" = "yes" ] && [ "$VCVRACK_START" = "yes" ] && [ "$VCVRACK_PID" = "" ]; } \
    || { [ "$1" = "menu" ] && [ "$VCVRACK_PID" = "" ]; }; then
  export VCVRACK_VERSION
  if [ "$DISPLAY_MODE" != "virtual" ] || [ "$DISPLAY_MODE" != "headless" ]; then
    if [ "$LDLP_PRE_EXTRA" = "" ]; then
      export LD_LIBRARY_PATH=/opt/libgl
    fi
  else
    export LD_LIBRARY_PATH="/opt/gl4es:/opt/libgl"
  fi
  cd /home/sonaremin/vcvrack-${VCVRACK_VERSION}
  sync
  sleep 5
  sync
  exec /home/sonaremin/bin/run-rack.sh
fi
