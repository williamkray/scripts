#!/usr/bin/env bash
bash ~/.screenlayout/default.sh
bash ~/.scripts/fehbg.sh &
xscreensaver &
compton -c -D 2 --inactive-dim .1 -b
exec dwm
