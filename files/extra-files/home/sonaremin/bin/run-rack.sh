#!/bin/bash

if [ -f /data/config/info.txt ]; then
  . /data/config/info.txt
fi

if [ -f /data/config/sonaremin.txt ]; then
  . /data/config/sonaremin.txt
else
  # start with a hdmi monitor connected (display) or virtual
  DISPLAY_MODE=display
  #DISPLAY_MODE=virtual
  #DISPLAY_MODE=headless
  # which vcvrack version to start automativally
  #VCVRACK_VERSION=v0
  VCVRACK_VERSION=v1
fi

if [ "$DISPLAY_MODE" = "headless" ]; then
  if [ "$VCVRACK_VERSION" = "v0" ]; then
    mv -f /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv.display
  else
    mv -f /home/sonaremin/vcvrack-${VCVRACK_VERSION}/autosave.vcv /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv.display
  fi
  STARTUP_FILE="/data/vcvrack-${VCVRACK_VERSION}/sonaremin.vcv"
else
  if [ "$VCVRACK_VERSION" = "v0" ]; then
    mv -f /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv.display /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv
  else
    mv -f /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv.display /home/sonaremin/vcvrack-${VCVRACK_VERSION}/autosave.vcv
  fi
  if [ "$VCVRACK_VERSION" = "v0" ]; then
    if [ ! -s /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv ]; then
      rm -f /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv
    fi
  else
    if [ ! -s /home/sonaremin/vcvrack-${VCVRACK_VERSION}/autosave.vcv ]; then
      rm -f /home/sonaremin/vcvrack-${VCVRACK_VERSION}/autosave.vcv
    fi
  fi
  STARTUP_FILE=""
fi

if [ "$REALTIME_PRIORITY_V0" = "true" ]; then
  RT_PRIO_V0="chrt 20"
else
  RT_PRIO_V0=""
fi

if [ "$REALTIME_PRIORITY_V1" = "true" ]; then
  # wait a moment until vcvrack has started up completely
  ( sleep 30 ; sudo /home/sonaremin/bin/set-rtprio-and-cpu-affinity.sh ) &
fi

if [ "$VCVRACK_VERSION" = "v0" ]; then
  exec $RT_PRIO_V0 ./Rack -d $STARTUP_FILE
else
  if [ "$RESET_REALTIME" = "true" ]; then
    # disable real time prio for vcvrack as it sometimes hangs the system on startup
    # it is reenabled later via the set-rtprio-and-cpu-affinity.sh script
    sed -i.backup-run-rack 's/"realTime":\ true,/"realTime": false,/g' /data/vcvrack-v1/config/settings.json
  fi
  exec ./Rack -d $STARTUP_FILE
fi
