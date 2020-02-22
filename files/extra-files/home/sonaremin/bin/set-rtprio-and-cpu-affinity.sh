#!/bin/bash
#
# this script is run to raise the realtime scheduling priority
# of the vcvrack audio threads and assign them to certain cpu cores
#
# this is done this way as when the vcvrack internal realtime
# priority setting is used the system sometimes locked up on startup
#
# the cpu affinity is used to push the vcvrack audio threads away
# from cpu cores which are maybe busy with other stuff like interrupt
# handling (like for instance cpu0 on the raspberry pi 3) or to
# schedule the audio threads to the big cores in big-little socs
#
# the same is done for the realtime relevant jackbus thread

# read the sonaremin config file if it exists, otherwise set default values
if [ -f /data/config/sonaremin.txt ]; then
  . /data/config/sonaremin.txt
fi

if [ "${DESIRED_CPU_AFFINITY}" = "" ]; then
  # on which cpu cores should vcvrack run - default: 3+4 (0 = cpu1 etc.)
  DESIRED_CPU_AFFINITY="2,3"
fi

if [ "${DESIRED_CPU_AFFINITY_JACK}" = "" ]; then
  # on which cpu cores should jack run - default: 1 (0 = cpu1 etc.)
  DESIRED_CPU_AFFINITY_JACK="1"
fi

DESIRED_RT_PRIORITY="50"

# set this script itself to cpu core 0 and unimportant scheduling prio
taskset -a -pc 1 $$ > /dev/null
chrt -o -p $$ > /dev/null

# vcvrack
VCVRACK_PID=`pidof Rack`
if [ "${VCVRACK_PID}" != "" ]; then
  for i in `top -p ${VCVRACK_PID} -b -n 1 -H | sed 1,7d | grep Engine | awk '{print $1}'`; do
    CURRENT_PRIORITY=`chrt -p $i | grep priority | sed 's,.*scheduling priority: ,,g'`
    if [ "${CURRENT_PRIORITY}" != "${DESIRED_RT_PRIORITY}" ]; then
      # set realtime scheduling priority
      chrt -p ${DESIRED_RT_PRIORITY} $i
    fi
    CURRENT_AFFINITY=`taskset -pc $i | sed 's,.*list: ,,g'`
    if [ "${CURRENT_AFFINITY}" != "${DESIRED_CPU_AFFINITY}" ]; then
      # set cpu affinity
      taskset -pc ${DESIRED_CPU_AFFINITY} $i > /dev/null
    fi
  done
fi

# jack
JACK_PID=`pidof jackdbus`
if [ "${JACK_PID}" != "" ]; then
  for i in `top -p ${JACK_PID} -b -n 1 -H | sed 1,7d | grep '\-11' | awk '{print $1}'`; do
    CURRENT_PRIORITY=`chrt -p $i | grep priority | sed 's,.*scheduling priority: ,,g'`
    if [ "${CURRENT_PRIORITY}" != "${DESIRED_RT_PRIORITY}" ]; then
      # set realtime scheduling priority
      chrt -p ${DESIRED_RT_PRIORITY} $i
    fi
    CURRENT_AFFINITY=`taskset -pc $i | sed 's,.*list: ,,g'`
    if [ "${CURRENT_AFFINITY}" != "${DESIRED_CPU_AFFINITY_JACK}" ]; then
      # set cpu affinity
      taskset -pc ${DESIRED_CPU_AFFINITY_JACK} $i > /dev/null
    fi
  done
fi
