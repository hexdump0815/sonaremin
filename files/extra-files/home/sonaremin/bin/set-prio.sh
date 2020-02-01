#!/bin/bash
#
# this script is started on boot to always give real time scheduling
# to the two Rack processes with the highest cpu usage - usually the
# audio threads as the main/ui thread is excluded from the list - this
# is done in an endless loop every 15 seconds

while true; do
  RACK_PID=`ps au | grep -v grep | grep Rack | awk '{print $2}'`
  if [ "${RACK_PID}" != "" ]; then
    for i in `ps auH -T | grep -v grep | grep Rack | awk '{print $3" "$4}' | grep -v ${RACK_PID} | tail -n 2 | awk '{print $1}'`; do
      chrt --pid 20 $i
    done
  fi
  sleep 15
done
