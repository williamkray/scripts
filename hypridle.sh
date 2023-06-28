#!/usr/bin/env bash

swayidle \
  timeout 300 'screen-locker.sh' \
    resume 'hyprctl dispatcher dpms on"' \
  before-sleep 'screen-locker.sh' &
