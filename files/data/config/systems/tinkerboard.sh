grep -q 'Rockchip RK3288 Asus Tinker Board$' /proc/device-tree/model
if [ "$?" = "0" ]; then
  # tinkerboard
  if [ "$DISPLAY_MODE" = "display" ]; then
    ln -sf /opt/mali-rk3288-armv7l /opt/libgl
  else
    # the LIBGL_FB=3 mode with fbdev mali only works as long as
    # /dev/fb0 is not in use, so thus only in non display mode
    ln -sf /opt/mali-rk3288-fbdev-armv7l /opt/libgl
  fi
  ln -sf /opt/gl4es-armv7l /opt/gl4es
  cp /data/config/x11/xorg.conf-rk3288 /etc/X11/xorg.conf.d/xorg.conf
  # check if a custom audio setup exists and use it in that case
  if [ -f /data/config/custom/audio-setup.sh ]; then
    . /data/config/custom/audio-setup.sh
  else
    cp /data/config/qjackctl/QjackCtl.conf-pcm2704 /data/config/qjackctl/QjackCtl.conf
    ( sleep 15; AUDIO_DEVICE=`aplay -l | grep "DAC \[USB AUDIO    DAC\]" | awk '{print $2}' | sed 's,:,,g'`; if [ "$AUDIO_DEVICE" != "" ]; then amixer -c ${AUDIO_DEVICE} set PCM 64 ; fi ) &
  fi
  if [ -f /data/config/sonaremin.txt ]; then
    . /data/config/sonaremin.txt
  fi
  # if no cpu clock limitation is defined, then set it for thermal safety
  if [ "$MAX_CPU_CLOCK" = "" ]; then
    MAX_CPU_CLOCK=1200000
  fi
  if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq ]; then
    for i in /sys/devices/system/cpu/cpu?/cpufreq/scaling_max_freq ; do
      echo $MAX_CPU_CLOCK > $i
    done
  fi
  echo "SYSTEM_MODEL=rk3288" > /data/config/info.txt
  echo "SYSTEM_MODEL_DETAILED=tinkerboard" >> /data/config/info.txt
  # start vcvrack v0 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V0=false" >> /data/config/info.txt
  # change to vt8 before starting the x server
  echo CHVT="true" >> /data/config/info.txt
  # extra addition in front of the LD_LIBRARY_PATH when starting vcvrack
  echo LDLP_PRE_EXTRA="/opt/gl4es" >> /data/config/info.txt
  if [ "$DISPLAY_MODE" != "display" ]; then
    # gl4es mode - this allows mali gpu accel even with xpra in virtual mode
    echo LIBGL_FB=3 >> /data/config/info.txt
  fi
fi
