#!/usr/bin/env bash

swayidle -w \
  timeout 300 'screen-locker.sh' \
    resume 'hyprctl dispatcher dpms on"' \
  before-sleep 'hypr-laptop-lid.sh && screen-locker.sh' &
