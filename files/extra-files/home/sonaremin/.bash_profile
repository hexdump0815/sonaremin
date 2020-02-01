if [[ ! ${DISPLAY} && ${XDG_VTNR} == 8 ]]; then
  if [ -f /data/config/info.txt ]; then
    . /data/config/info.txt
  else
    # change to vt8 before starting the x server
    CHVT="false"
    # set an extra LD_LIBRARY_PATH when starting the xserver
    LDLP=""
  fi
  if [ -f /data/config/sonaremin.txt ]; then
    . /data/config/sonaremin.txt
  fi

  if [ "$CHVT" = "true" ]; then
    chvt 8
    sleep 5
  fi
  if [ "$LDLP" != "" ]; then
    export LD_LIBRARY_PATH=$LDLP
  fi
  if [ "$LIBGL_FB" != "" ]; then
    export LIBGL_FB
  fi
  exec startx
fi
