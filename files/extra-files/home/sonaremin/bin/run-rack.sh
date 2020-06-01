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
  VCVRACK_VERSION=v1
fi

if [ "$DISPLAY_MODE" = "headless" ]; then
  mv -f /home/sonaremin/vcvrack-${VCVRACK_VERSION}/autosave.vcv /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv.display
  STARTUP_FILE="/data/vcvrack-${VCVRACK_VERSION}/sonaremin.vcv"
else
  mv -f /data/vcvrack-${VCVRACK_VERSION}/config/autosave.vcv.display /home/sonaremin/vcvrack-${VCVRACK_VERSION}/autosave.vcv
  if [ ! -s /home/sonaremin/vcvrack-${VCVRACK_VERSION}/autosave.vcv ]; then
    rm -f /home/sonaremin/vcvrack-${VCVRACK_VERSION}/autosave.vcv
  fi
  STARTUP_FILE=""
fi

if [ "$REALTIME_PRIORITY_V1" = "true" ]; then
  # wait a moment until vcvrack has started up completely
  ( sleep 30 ; sudo /home/sonaremin/bin/set-rtprio-and-cpu-affinity.sh ) &
fi

if [ "$RESET_REALTIME" = "true" ]; then
  # disable real time prio for vcvrack as it sometimes hangs the system on startup
  # it is reenabled later via the set-rtprio-and-cpu-affinity.sh script
  sed -i.backup-run-rack 's/"realTime":\ true,/"realTime": false,/g' /data/vcvrack-v1/config/settings.json
fi
exec ./Rack -d $STARTUP_FILE
