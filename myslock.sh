#!/bin/bash

#sleep .1 && slock -c "#8C9440" -d
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
convert $file -scale 10% -scale 1000% "/home/william/Pictures/Icons/lock.png" -gravity center -composite -matte $file
lock $file

#revert
