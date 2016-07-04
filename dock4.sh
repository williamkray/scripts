#!/bin/sh
xrandr --output DP-2-1 --primary  --mode 1920x1080  --pos 0x0 --rotate normal  
xrandr --output eDP-1 --mode 1920x1080_60.00 --pos 0x1080 --rotate normal  
sleep 1
xrandr --output DP-2-2 --mode 1920x1080  --pos 1920x0 --rotate left  
fehbg.sh
