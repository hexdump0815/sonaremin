grep -q 'LeMaker Banana Pi$' /proc/device-tree/model
if [ "$?" = "0" ]; then
  # bananapi m1
  ln -s /opt/mali-sunxi /opt/libgl
  cp /data/config/x11/xorg.conf-sunxi /etc/X11/xorg.conf.d/xorg.conf
  cp /data/qjackctl/QjackCtl.conf-pcm2704 /data/qjackctl/QjackCtl.conf
  ( sleep 15; AUDIO_DEVICE=`aplay -l | grep "DAC \[USB AUDIO    DAC\]" | awk '{print $2}' | sed 's,:,,g'`; amixer -c ${AUDIO_DEVICE} set PCM 64 ) &
  echo "SYSTEM_MODEL=bananapi_m1" > /data/config/info.txt
  echo "SYSTEM_MODEL_DETAILED=bananapi_m1" >> /data/config/info.txt
  # start vcvrack v0 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V0=false" >> /data/config/info.txt
  # start vcvrack v1 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V1=false" >> /data/config/info.txt
  # change to vt8 before starting the x server
  echo CHVT="true" >> /data/config/info.txt
fi
