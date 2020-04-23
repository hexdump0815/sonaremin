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
  if [ "$SYSTEM_MODEL" = "raspberrypi" ]; then
    export LD_LIBRARY_PATH=/opt/libgl
  # otherwise bypass the accelerated opengl here as it is safer this way
  else
    if [ -d /usr/lib/arm-linux-gnueabihf ]; then
      export LD_LIBRARY_PATH=/usr/lib/arm-linux-gnueabihf
    elif [ -d /usr/lib/aarch64-linux-gnu ]; then
      export LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu
    fi
  fi
  if [ "$JACKD_NET" = "yes" ]; then
    jackd -d net -i 4 -o 4 -C 2 -P 2 & 
    /home/sonaremin/bin/start-a2jmidid.sh &
    exec qjackctl
  else
    exec qjackctl --start
  fi
fi
