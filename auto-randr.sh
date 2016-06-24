#!/bin/bash

xrandr_output="$(xrandr)"

if [ -n "$( echo \"$xrandr_output\"|grep 'DP2-1 connected')" ]; then
  dock3.sh
  sudo dhcpcd dock0
else
  if [ -n "$( echo \"$xrandr_output\"|grep ' DP1 connected')" ]; then
    dock_bb.sh
  else
    undock.sh
    sudo dhcpcd -k dock0
  fi
fi

auto-pulse.sh
#xfce4-panel -r
