grep -q 'Hardkernel Odroid MC1$' /proc/device-tree/model
if [ "$?" = "0" ]; then
  # odroid mc1
  if [ "$DISPLAY_MODE" = "display" ]; then
    # no hdmi supported on this system as it has no hdmi connector
    # so switch display mode to virtual
    DISPLAY_MODE=virtual
  fi
  ln -sf /opt/mali-exynos5422-fbdev-armv7l /opt/libgl
  ln -sf /opt/gl4es-armv7l /opt/gl4es
  cp /data/config/x11/xorg.conf-modesetting /etc/X11/xorg.conf.d/xorg.conf
  # check if a custom audio setup exists and use it in that case
  if [ -f /data/config/custom/audio-setup.sh ]; then
    . /data/config/custom/audio-setup.sh
  else
    # the odroid mc1 does not have an audio output jack, so lets use usb audio instead
    cp /data/config/qjackctl/QjackCtl.conf-pcm2704 /data/config/qjackctl/QjackCtl.conf
    ( sleep 15; AUDIO_DEVICE=`aplay -l | grep "DAC \[USB AUDIO    DAC\]" | awk '{print $2}' | sed 's,:,,g'`; if [ "$AUDIO_DEVICE" != "" ]; then amixer -c ${AUDIO_DEVICE} set PCM 64 ; fi ) &
  fi
  echo "SYSTEM_MODEL=exynos5422" > /data/config/info.txt
  echo "SYSTEM_MODEL_DETAILED=odroid_mc1" >> /data/config/info.txt
  # limit the cpu clock to avoid overheating
  # possible values: cat /sys/devices/system/cpu/cpufreq/policy?/scaling_available_frequencies
  #echo MAX_CPU_CLOCK=1608000 >> /data/config/info.txt
  # set the cpu cores vcvrack and jack should run on - we avoid cpu0 as it has to deal
  # more with irq handling etc. - used in set-rtprio-and-cpu-affinity.sh
  echo DESIRED_CPU_AFFINITY=4,5 >> /data/config/info.txt
  echo DESIRED_CPU_AFFINITY_JACK=1 >> /data/config/info.txt
  # allow to disable certain cpu cores to reduce the heat created by the cpu the sonaremin
  # should be fine with 3 out of 4 cores for instance ... this is a space separated list
  echo DISABLE_CPU_CORES=\"2 3 6 7\" >> /data/config/info.txt
  # change to vt8 before starting the x server
  echo CHVT="true" >> /data/config/info.txt
  # extra addition in front of the LD_LIBRARY_PATH when starting vcvrack
  echo LDLP_PRE_EXTRA="/opt/gl4es" >> /data/config/info.txt
  # gl4es mode - this allows mali gpu accel even with xpra in virtual mode
  echo LIBGL_FB=3 >> /data/config/info.txt
fi
