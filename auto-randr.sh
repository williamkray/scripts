#!/bin/bash
export DISPLAY=:0

xrandr_output="$(xrandr)"

if [ -n "$( echo \"$xrandr_output\"|grep 'DP1-1 connected')" ]; then
  dock5.sh
  #sudo dhcpcd dock0
else
  if [ -n "$( echo \"$xrandr_output\"|grep ' DP-1 connected')" ]; then
    one-monitor.sh
  else
    undock.sh
    #sudo dhcpcd -k dock0
  fi
fi

#fehbg.sh
#auto-pulse.sh
#xfce4-panel -r
