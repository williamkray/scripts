#!/bin/bash

bt_status=$(rfkill list bluetooth | grep "blocked: yes")

if [[ -z $bt_status ]]; then
  bt_connections=$(find /sys/class/bluetooth/hci0/ -type d -name hci0:* | wc -l)
  if [[ $bt_connections -lt 1 ]]; then
    msg="no devices"
  elif [[ $bt_connections -gt 1 ]]; then
    msg="$bt_connections devices"
  else
    msg="$bt_connections device"
  fi
else
  msg="off"
fi
echo "$msg"
