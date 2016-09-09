#!/bin/bash

#sleep .1 && slock -c "#8C9440" -d
file="/tmp/lock.png"

revert() {
  xset dpms 0 0 0
}

trap revert SIGHUP SIGINT SIGTERM

#xset +dpms dpms 5 5 5
scrot $file
convert $file -scale 10% -scale 1000% $file
i3lock -n -u -i $file

#revert
