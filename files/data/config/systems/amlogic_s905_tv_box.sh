grep -q 'NEXBOX A95X$' /proc/device-tree/model
if [ "$?" = "0" ]; then
  # amlogic s905 tv box
  ln -s /opt/mali-s905 /opt/libgl
  cp /data/config/x11/xorg.conf-s905 /etc/X11/xorg.conf.d/xorg.conf
  cp /data/qjackctl/QjackCtl.conf-pcm2704 /data/qjackctl/QjackCtl.conf
  ( sleep 15; AUDIO_DEVICE=`aplay -l | grep "DAC \[USB AUDIO    DAC\]" | awk '{print $2}' | sed 's,:,,g'`; amixer -c ${AUDIO_DEVICE} set PCM 64 ) &
  echo "SYSTEM_MODEL=s905" > /data/config/info.txt
  echo "SYSTEM_MODEL_DETAILED=amlogic_s905_tv_box" >> /data/config/info.txt
  # start vcvrack v0 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V0=false" >> /data/config/info.txt
  # start vcvrack v1 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V1=false" >> /data/config/info.txt
  # change to vt8 before starting the x server
  echo CHVT="false" >> /data/config/info.txt
fi
