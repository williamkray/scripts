#!/bin/bash

case "$1" in
  up)
    amixer -D pulse set Master 5%+ unmute
    ;;
  down)
    amixer -D pulse set Master 5%- unmute
    ;;
  toggle)
    amixer -D pulse set Master toggle
esac
