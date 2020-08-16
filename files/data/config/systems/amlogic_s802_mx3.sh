grep -q 'Tronsmart MXIII$' /proc/device-tree/model
if [ "$?" = "0" ]; then
  # mx3
  if [ "$DISPLAY_MODE" = "display" ]; then
    # no hdmi or mali supported yet on this system, so use mesa software
    # opengl rendering (i.e. no mali and no gl4es) with max 1 thread and
    # switch display mode to virtual
    DISPLAY_MODE=virtual
    ln -sf /dev/null /opt/libgl
    ln -sf /dev/null /opt/gl4es
    export LP_NUM_THREADS=1
  else
    # in cese we are not in display mode use mesa software opengl
    # rendering (i.e. no mali and no gl4es) with max 1 thread
    ln -sf /dev/null /opt/libgl
    ln -sf /dev/null /opt/gl4es
    export LP_NUM_THREADS=1
  fi
  cp /data/config/x11/xorg.conf-modesetting /etc/X11/xorg.conf.d/xorg.conf
  # check if a custom audio setup exists and use it in that case
  if [ -f /data/config/custom/audio-setup.sh ]; then
    . /data/config/custom/audio-setup.sh
  else
    cp /data/config/qjackctl/QjackCtl.conf-pcm2704 /data/config/qjackctl/QjackCtl.conf
    ( sleep 15; AUDIO_DEVICE=`aplay -l | grep "DAC \[USB AUDIO    DAC\]" | awk '{print $2}' | sed 's,:,,g'`; if [ "$AUDIO_DEVICE" != "" ]; then amixer -c ${AUDIO_DEVICE} set PCM 64 ; fi ) &
  fi
  echo "SYSTEM_MODEL=m8x" > /data/config/info.txt
  echo "SYSTEM_MODEL_DETAILED=amlogic_s802_mx3" >> /data/config/info.txt
  # limit the cpu clock to avoid overheating
  # possible values: cat /sys/devices/system/cpu/cpufreq/policy?/scaling_available_frequencies
  #echo MAX_CPU_CLOCK=1200000 >> /data/config/info.txt
  # set the cpu cores vcvrack and jack should run on - we avoid cpu0 as it has to deal
  # more with irq handling etc. - used in set-rtprio-and-cpu-affinity.sh
  echo DESIRED_CPU_AFFINITY=2,3 >> /data/config/info.txt
  echo DESIRED_CPU_AFFINITY_JACK=1 >> /data/config/info.txt
  # allow to disable certain cpu cores to reduce the heat created by the cpu the sonaremin
  # should be fine with 3 out of 4 cores for instance ... this is a space separated list
  # better do not disable anything on this weak system, set jack affinity to 0 in case of disabling 1 anyway
  #echo DISABLE_CPU_CORES=\"1\" >> /data/config/info.txt
  # # change to vt8 before starting the x server
  # echo CHVT="true" >> /data/config/info.txt
  # # extra addition in front of the LD_LIBRARY_PATH when starting vcvrack
  # echo LDLP_PRE_EXTRA="/opt/gl4es" >> /data/config/info.txt
fi
