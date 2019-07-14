#!/bin/sh

echo "start of startup-local.sh"
if [ -x /data/config/startup/rc.xsession-local ]; then
  sleep 15
  /data/config/startup/rc.xsession-local
fi
echo "end of startup-local.sh"
