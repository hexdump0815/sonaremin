grep -q 'Libre Computer Board ALL-H3-CC H3$' /proc/device-tree/model
if [ "$?" = "0" ]; then
  # allwinner h3 tv box
  ln -s /opt/mali-sunxi /opt/libgl
  cp /data/config/x11/xorg.conf-sunxi /etc/X11/xorg.conf.d/xorg.conf
  cp /data/config/qjackctl/QjackCtl.conf-h3 /data/config/qjackctl/QjackCtl.conf
  ( sleep 15; AUDIO_DEVICE=`aplay -l | grep "H3 Audio Codec" | awk '{print $2}' | sed 's,:,,g'`; if [ "$AUDIO_DEVICE" != "" ]; then amixer -c ${AUDIO_DEVICE} set 'Line Out' 31 ; amixer -c ${AUDIO_DEVICE} set DAC 63 ; fi ) &
  echo "SYSTEM_MODEL=h3" > /data/config/info.txt
  echo "SYSTEM_MODEL_DETAILED=allwinner_h3_tv_box" >> /data/config/info.txt
  # start vcvrack v0 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V0=false" >> /data/config/info.txt
  # start vcvrack v1 with realtime scheduling priority - might result in system hangs
  echo "REALTIME_PRIORITY_V1=false" >> /data/config/info.txt
  # change to vt8 before starting the x server
  echo CHVT="true" >> /data/config/info.txt
fi
