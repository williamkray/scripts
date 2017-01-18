#!/bin/sh
if [[ -z $(iwgetid |grep kray) ]]; then
  ornt="right"
else
  ornt="left"
fi
xrandr --output DP2-1 --primary  --mode 1920x1080  --pos 0x0 --rotate normal  
xrandr --output eDP1 --mode 1920x1080_60.00 --pos 0x1080 --rotate normal  
sleep 1
xrandr --output DP2-2 --mode 1920x1080  --pos 1920x0 --rotate $ornt
fehbg.sh
