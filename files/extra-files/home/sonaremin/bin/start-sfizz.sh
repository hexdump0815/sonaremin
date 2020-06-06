#!/bin/bash

# read the sonaremin config file if it exists, otherwise set default values
if [ -f /data/config/sonaremin.txt ]; then
  . /data/config/sonaremin.txt
else
  # start up to 4 sfizz sfz sample engines
  SFIZZ_01=""
  SFIZZ_02=""
  SFIZZ_03=""
  SFIZZ_04=""
  # preload sfz sample files into the filesystem buffer
  SFIZZ_PRELOAD=yes
  #SFIZZ_PRELOAD=no
fi

# if we are called from the menu and there are any sfizz instances - stop them
if [ "$1" = "menu" ]; then
  for i in `ps auxwww | grep sfizz_jack | grep -v grep | awk '{print $2}'`; do
    kill ${i}
  done
fi
# iterate over the 4 sfizz instances and start them if a sfz file is defined
# sfizz samples are preloaded into the filesystem bufffer by reading them
# once from disk to /dev/null
if [ "${SFIZZ_01}" != "" ]; then
  if [ -f "/data/sfizz-samples/${SFIZZ_01}" ]; then
    if [ "${SFIZZ_PRELOAD}" == "yes" ]; then
      # first assume by default we have a dir with the same base name
      # as the sfz file containing the samples
      SAMPLE_DIR=`echo /data/sfizz-samples/${SFIZZ_01} | sed 's,\.sfz$,,g'`
      if [ -d "${SAMPLE_DIR}" ] && [ "${SFIZZ_PRELOAD}" == "yes" ]; then
        find ${SAMPLE_DIR} -type f -exec cat {} > /dev/null \;
      fi
      # otherwise there is the option to explicitly define the sample dir
      if [ "${SFIZZ_01_PRELOADDIR}" != "" ] && [ -d "/data/sfizz-samples/${SFIZZ_01_PRELOADDIR}" ]; then
        find /data/sfizz-samples/${SFIZZ_01_PRELOADDIR} -type f -exec cat {} > /dev/null \;
      fi
    fi
    /usr/local/bin/sfizz_jack --client_name sfizz-01 /data/sfizz-samples/${SFIZZ_01} &
  fi
fi
if [ "${SFIZZ_02}" != "" ]; then
  if [ -f "/data/sfizz-samples/${SFIZZ_02}" ]; then
    if [ "${SFIZZ_PRELOAD}" == "yes" ]; then
      # first assume by default we have a dir with the same base name
      # as the sfz file containing the samples
      SAMPLE_DIR=`echo /data/sfizz-samples/${SFIZZ_02} | sed 's,\.sfz$,,g'`
      if [ -d "${SAMPLE_DIR}" ] && [ "${SFIZZ_PRELOAD}" == "yes" ]; then
        find ${SAMPLE_DIR} -type f -exec cat {} > /dev/null \;
      fi
      # otherwise there is the option to explicitly define the sample dir
      if [ "${SFIZZ_02_PRELOADDIR}" != "" ] && [ -d "/data/sfizz-samples/${SFIZZ_02_PRELOADDIR}" ]; then
        find /data/sfizz-samples/${SFIZZ_02_PRELOADDIR} -type f -exec cat {} > /dev/null \;
      fi
    fi
    /usr/local/bin/sfizz_jack --client_name sfizz-01 /data/sfizz-samples/${SFIZZ_02} &
  fi
fi
if [ "${SFIZZ_03}" != "" ]; then
  if [ -f "/data/sfizz-samples/${SFIZZ_03}" ]; then
    if [ "${SFIZZ_PRELOAD}" == "yes" ]; then
      # first assume by default we have a dir with the same base name
      # as the sfz file containing the samples
      SAMPLE_DIR=`echo /data/sfizz-samples/${SFIZZ_03} | sed 's,\.sfz$,,g'`
      if [ -d "${SAMPLE_DIR}" ] && [ "${SFIZZ_PRELOAD}" == "yes" ]; then
        find ${SAMPLE_DIR} -type f -exec cat {} > /dev/null \;
      fi
      # otherwise there is the option to explicitly define the sample dir
      if [ "${SFIZZ_03_PRELOADDIR}" != "" ] && [ -d "/data/sfizz-samples/${SFIZZ_03_PRELOADDIR}" ]; then
        find /data/sfizz-samples/${SFIZZ_03_PRELOADDIR} -type f -exec cat {} > /dev/null \;
      fi
    fi
    /usr/local/bin/sfizz_jack --client_name sfizz-01 /data/sfizz-samples/${SFIZZ_03} &
  fi
fi
if [ "${SFIZZ_04}" != "" ]; then
  if [ -f "/data/sfizz-samples/${SFIZZ_04}" ]; then
    if [ "${SFIZZ_PRELOAD}" == "yes" ]; then
      # first assume by default we have a dir with the same base name
      # as the sfz file containing the samples
      SAMPLE_DIR=`echo /data/sfizz-samples/${SFIZZ_04} | sed 's,\.sfz$,,g'`
      if [ -d "${SAMPLE_DIR}" ] && [ "${SFIZZ_PRELOAD}" == "yes" ]; then
        find ${SAMPLE_DIR} -type f -exec cat {} > /dev/null \;
      fi
      # otherwise there is the option to explicitly define the sample dir
      if [ "${SFIZZ_04_PRELOADDIR}" != "" ] && [ -d "/data/sfizz-samples/${SFIZZ_04_PRELOADDIR}" ]; then
        find /data/sfizz-samples/${SFIZZ_04_PRELOADDIR} -type f -exec cat {} > /dev/null \;
      fi
    fi
    /usr/local/bin/sfizz_jack --client_name sfizz-01 /data/sfizz-samples/${SFIZZ_04} &
  fi
fi
# wait a moment
sleep 5
# sfizz automatically connects to the system audio out jack port
# this we do not want - so disconnect from it again
jack_disconnect sfizz-01:output_1 system:playback_1
jack_disconnect sfizz-01:output_2 system:playback_2
jack_disconnect sfizz-02:output_1 system:playback_3
jack_disconnect sfizz-02:output_2 system:playback_4
jack_disconnect sfizz-03:output_1 system:playback_5
jack_disconnect sfizz-03:output_2 system:playback_6
jack_disconnect sfizz-04:output_1 system:playback_7
jack_disconnect sfizz-04:output_2 system:playback_8
# do it again for the non network jackd case where all will connect to _1 and _2
jack_disconnect sfizz-02:output_1 system:playback_1
jack_disconnect sfizz-02:output_2 system:playback_2
jack_disconnect sfizz-03:output_1 system:playback_1
jack_disconnect sfizz-03:output_2 system:playback_2
jack_disconnect sfizz-04:output_1 system:playback_1
jack_disconnect sfizz-04:output_2 system:playback_2
