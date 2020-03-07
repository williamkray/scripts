#!/bin/bash

## check what our options are
if [[ $(which xscreensaver-command) ]]; then
  xscreensaver-command -lock
elif [[ $(which xautolock) && $(which i3lock) && $(which escrotum) ]]; then
  file="/tmp/lock.png"
  revert() {
    xset dpms 0 0 0
  }
  lock() {
    i3lock -n -i $1 \
      --insidecolor=373445ff --ringcolor=ffffffff --line-uses-inside \
      --keyhlcolor=d23c3dff --bshlcolor=d23c3dff --separatorcolor=00000000 \
      --insidevercolor=fecf4dff --insidewrongcolor=d23c3dff \
      --ringvercolor=ffffffff --ringwrongcolor=ffffffff \
      --radius=15 --veriftext="" --wrongtext=""
  }

  trap revert SIGHUP SIGINT SIGTERM
  #xset +dpms dpms 5 5 5
  escrotum $file
  convert $file -scale 5% -scale 2000% $file
  lock $file
  #revert
else
  echo "no recognized screen locker configurations, exiting"
  exit 1
fi
