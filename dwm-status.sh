#!/usr/bin/env bash

while true; do

  time_local=$(date +%I:%M%p)
  time_utc=$(date -u +%H:%M)
  charging=$(cat /sys/class/power_supply/AC/online)
  bat0=$(cat /sys/class/power_supply/BAT0/capacity)
  if [[ -f /sys/class/power_supply/BAT1/capacity ]]; then
    bat1=$(cat /sys/class/power_supply/BAT1/capacity)
  else
    bat1=$bat0
  fi
  battotal=$( expr $bat0 + $bat1 )
  batavg=$( expr $battotal / 2 )
  #bt=$(bluetooth-stat.sh)

  xsetroot -name " BAT:${batavg} | ${time_local} [${time_utc}] "
  sleep 2

done
