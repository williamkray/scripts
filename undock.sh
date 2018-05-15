#!/bin/sh
xrandr --output DP1 --off
xrandr --output DP2 --off
xrandr --output DP2-1 --off
xrandr --output DP2-2 --off
xrandr --output VIRTUAL1 --off
sleep 1
xrandr --auto
xrandr --output eDP-1 --primary
fehbg.sh
