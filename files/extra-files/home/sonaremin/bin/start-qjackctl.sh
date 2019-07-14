#!/bin/bash

# read the sonaremin config file if it exists, otherwise set default values
if [ -f /data/config/sonaremin.txt ]; then
  . /data/config/sonaremin.txt
else
  # start qjackctl automatically
  QJACKCTL_START=yes
  #QJACKCTL_START=no
  # start jackd in network mode
  #JACKD_NET=yes
  JACKD_NET=no
fi

if [ -f /data/config/info.txt ]; then
  . /data/config/info.txt
fi

QJACKCTL_PID=`pidof qjackctl`
if { [ "$QJACKCTL_START" = "yes" ] && [ "$QJACKCTL_PID" = "" ]; } \
    || { [ "$1" = "menu" ] && [ "$QJACKCTL_PID" = "" ]; }; then
  export JACK_NO_AUDIO_RESERVATION=1
  MYARCH=`uname -m`
  # qjackctl needs to use mesa, otherwise it will segfault on the 32bit rpi
  if [ "$SYSTEM_MODEL" = "raspberrypi" ] && [ "$MYARCH" = "armv7l" ]; then
    export LD_LIBRARY_PATH=/opt/libgl
  fi
  if [ "$JACKD_NET" = "yes" ]; then
    jackd -d net -i 1 -o 1 & 
    /home/sonaremin/bin/start-a2jmidid.sh &
    exec qjackctl
  else
    exec qjackctl --start
  fi
fi
