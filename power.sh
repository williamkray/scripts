#!/bin/bash
## this is basically just a wrapper for
## powerdown and powerup scripts (from the AUR)
## to automatically figure out which one to run
## and then run other commands afterwards.

if [[ $(cat /sys/class/power_supply/AC/online) == 1 ]]; then
  sudo /usr/bin/powerup
else
  sudo /usr/bin/powerdown
fi

sudo -u william /home/william/Scripts/autorandr.sh
sudo -u william /home/william/Scripts/musicmount.sh
