#!/bin/bash

if [[ $(cat /sys/class/power_supply/AC/online) == 1 ]]; then
  sudo powerup
else
  sudo powerdown
fi

/home/william/Scripts/autorandr.sh
