#!/usr/bin/env bash
bash ~/.screenlayout/default.sh
bash ~/.scripts/fehbg.sh &
unclutter -noevents &
xautolock -noclose -time 5 -locker ~/.scripts/screen-locker.sh -corners ---+ -cornerdelay 0 -cornerredelay 600 &
compton -c -D 2 -b
~/.scripts/dwm-status.sh &
exec dwm
