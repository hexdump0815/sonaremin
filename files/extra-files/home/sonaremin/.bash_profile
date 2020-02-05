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
  else
    # if LIBGL_FB is not set we want to start xorg (armsoc in this case)
    # without gl4es and mali in LD_LIBRARY_PATH for sure
    if [ -d /usr/lib/arm-linux-gnueabihf ]; then
      export LD_LIBRARY_PATH=/usr/lib/arm-linux-gnueabihf
    elif [ -d /usr/lib/aarch64-linux-gnu ]; then
      export LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu
    fi
  fi
  exec startx
fi
