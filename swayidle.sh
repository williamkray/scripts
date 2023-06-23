#!/usr/bin/env bash

swayidle \
  timeout 300 'screen-locker.sh' \
  timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
  before-sleep 'swaylock -c 000000' &
