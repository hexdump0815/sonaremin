grep -q 'Raspberry Pi 3 Model B+$' /proc/device-tree/model
if [ "$?" = "0" ]; then
  # raspberry pi 3b plus
  if [ -d /opt/mesa-rpi/lib/aarch64-linux-gnu ]; then
    ln -s /opt/mesa-rpi/lib/aarch64-linux-gnu /opt/libgl
  else
    ln -s /opt/mesa-rpi/lib/arm-linux-gnueabihf /opt/libgl
  fi
  cp /data/config/x11/xorg.conf-raspberrypi /etc/X11/xorg.conf.d/xorg.conf
  cp /data/config/qjackctl/QjackCtl.conf-raspberrypi /data/config/qjackctl/QjackCtl.conf
  ( sleep 15; AUDIO_DEVICE=`aplay -l | grep "bcm2835 ALSA \[bcm2835 ALSA\]" | awk '{print $2}' | sed 's,:,,g'`; if [ "$AUDIO_DEVICE" != "" ]; then amixer -c ${AUDIO_DEVICE} set PCM 0 ; fi ) &
  echo "SYSTEM_MODEL=raspberrypi" > /data/config/info.txt
  echo "SYSTEM_MODEL_DETAILED=raspberrypi_3_b_plus" >> /data/config/info.txt
  # start vcvrack v0 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V0=false" >> /data/config/info.txt
  # start vcvrack v1 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V1=false" >> /data/config/info.txt
  # change to vt8 before starting the x server
  echo CHVT="true" >> /data/config/info.txt
  # set an extra LD_LIBRARY_PATH when starting the xserver and qjackctl
  echo LDLP="/opt/libgl" >> /data/config/info.txt
  # extra addition in front of the LD_LIBRARY_PATH when starting vcvrack
  echo LDLP_PRE_EXTRA="/opt/gl4es" >> /data/config/info.txt
fi
