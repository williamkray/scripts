#!/usr/bin/env bash

set -e
tmpfile="/tmp/screenlocknoti.tmp"

if [ -z $(pidof swayidle) ]; then
  swayidle.sh && notify-desktop -t 3000 -R "$tmpfile" "Screenlock: RESUMED"
else
  kill $(pidof swayidle) && notify-desktop -t 0 "Screenlock: PAUSED" > "$tmpfile"
fi
