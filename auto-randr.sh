#!/bin/bash

xrandr_output="$(xrandr)"

if [ -n "$( echo \"$xrandr_output\"|grep 'DP2-1 connected')" ]; then
  dock3.sh
else
  undock.sh
fi

auto-pulse.sh
xfce4-panel -r
