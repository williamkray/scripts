#!/usr/bin/env bash

## skip logic if no batteries
if [[ -z $(find /sys/class/power_supply/ -name BAT*) ]]; then
  batdisplay=""
else
  batdisplay="notset"
fi

## seems to be pretty reliable way of finding wlan devices
## skips logic if there are no wireless devices
if [[ -z $(ip link show | grep wl) ]]; then
  essid=""
else
  essid="NULL"
fi

while true; do

  ## current time in local and UTC
  time_local=" $(date +%I:%M%p\ %Z)"
  time_utc=" [$(date -u +%H:%M) UTC]"
  ## 
  if [[ -n $batdisplay ]]; then
    charging=$(cat /sys/class/power_supply/AC/online)
    if [[ $charging -gt 0 ]]; then
      chgdisplay="[C]"
    else
      chgdisplay=""
    fi
    bat0=$(cat /sys/class/power_supply/BAT0/capacity)
    if [[ -f /sys/class/power_supply/BAT1/capacity ]]; then
      bat1=$(cat /sys/class/power_supply/BAT1/capacity)
    else
      bat1=$bat0
    fi
  battotal=$( expr $bat0 + $bat1 )
  batavg=$( expr $battotal / 2 )
  batdisplay=" ${batavg}%${chgdisplay} |"
  fi
  if [[ -n $essid ]]; then
    connected_essid=$(iw wlp113s0 info | grep ssid | awk '{print $2}')
    essid=${connected_essid:-WiFi=NULL}
    essiddisplay=" $essid |"
  fi

  #bt=$(bluetooth-stat.sh)

  echo "${essiddisplay}${batdisplay}${time_local}${time_utc} "
  sleep 2

done
