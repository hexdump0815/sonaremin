grep -q 'NEXBOX A95X$' /proc/device-tree/model
if [ "$?" = "0" ]; then
  # amlogic s905 tv box
  if [ -d /opt/mali-s905-fbdev-aarch64 ]; then
    ln -sf /opt/mali-s905-fbdev-aarch64 /opt/libgl
    ln -sf /opt/gl4es-aarch64 /opt/gl4es
  else
    ln -sf /opt/mali-s905-fbdev-armv7l /opt/libgl
    ln -sf /opt/gl4es-armv7l /opt/gl4es
  fi
  cp /data/config/x11/xorg.conf-s905 /etc/X11/xorg.conf.d/xorg.conf
  # check if a custom audio setup exists and use it in that case
  if [ -f /data/config/custom/audio-setup.sh ]; then
    . /data/config/custom/audio-setup.sh
  else
    cp /data/config/qjackctl/QjackCtl.conf-pcm2704 /data/config/qjackctl/QjackCtl.conf
    ( sleep 15; AUDIO_DEVICE=`aplay -l | grep "DAC \[USB AUDIO    DAC\]" | awk '{print $2}' | sed 's,:,,g'`; if [ "$AUDIO_DEVICE" != "" ]; then amixer -c ${AUDIO_DEVICE} set PCM 64 ; fi ) &
  fi
  echo "SYSTEM_MODEL=s905" > /data/config/info.txt
  echo "SYSTEM_MODEL_DETAILED=amlogic_s905_tv_box" >> /data/config/info.txt
  # start vcvrack v0 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V0=false" >> /data/config/info.txt
  # change to vt8 before starting the x server
  echo CHVT="false" >> /data/config/info.txt
  # extra addition in front of the LD_LIBRARY_PATH when starting vcvrack
  echo LDLP_PRE_EXTRA="/opt/gl4es" >> /data/config/info.txt
  # gl4es mode - this allows mali gpu accel even with xpra in virtual mode
  echo LIBGL_FB=3 >> /data/config/info.txt
fi
