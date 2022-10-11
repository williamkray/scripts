#!/bin/bash

if [[ "$XDG_CURRENT_DESKTOP" = "sway" ]]; then
  kill -SIGUSR1 $(pidof swayidle)
  exit 0
fi

## check what our options are
if [[ $(which xscreensaver-command) ]]; then
  xscreensaver-command -lock
elif [[ $(which xautolock) && $(which i3lock) && $(which screencap.sh) ]]; then
  file="/tmp/lock.png"
  revert() {
    xset dpms 0 0 0
  }
  lock() {
    i3lock -n -i $1 \
      --inside-color=373445ff --ring-color=ffffffff --line-uses-inside \
      --keyhl-color=d23c3dff --bshl-color=d23c3dff --separator-color=00000000 \
      --insidever-color=fecf4dff --insidewrong-color=d23c3dff \
      --ringver-color=ffffffff --ringwrong-color=ffffffff \
      --radius=15 --verif-text="" --wrong-text=""

  }

  trap revert SIGHUP SIGINT SIGTERM
  xset +dpms dpms 5 5 5
  screencap.sh lock
  convert $file -scale 5% -scale 2000% $file
  xset dpms force off
  lock $file
  revert
else
  echo "no recognized screen locker configurations, exiting"
  exit 1
fi
