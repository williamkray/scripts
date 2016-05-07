#!/bin/bash

export PULSE_RUNTIME_PATH="/run/user/1000/pulse/"
#export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'

## find all pulse audio sinks (speakers)
get_sinks() {
  all_sinks=$(pacmd list-sinks|grep 'name: <'|sed -r 's/(name: <|>)//g')
  echo "Sinks found: $all_sinks"
}

## find all pulse audio sources (microphones)
get_sources() {
  all_sources=$(pacmd list-sources|grep 'name: <'|grep -v monitor|sed -r 's/(name: <|>)//g')
  echo "Sources found: $all_sources"
}

## determine some environmental factors
get_sinks
get_sources

## are we docked? check audio outputs
docked=false
if [[ $all_sinks =~ ([Dd]ock|_USB_Advanced_Audio_Device) ]]; then
  docked=true
fi

## set a sane default for audio input and output
default_sink=$(echo "$all_sinks"|sed -r 's/(\s+|\t+)/\r\n/g'|grep pci|grep -v hdmi)
default_source=$(echo $all_sources|sed -r 's/(\s+|\t+)/\r\n/g'|grep pci|grep -v hdmi)

## generate values for dock audio devices
dock_sink=$(echo $all_sinks|sed -r 's/(\s+|\t+)/\r\n/g'|egrep "[Dd]ock|_USB_Advanced_Audio_Device")
dock_source=$(echo $all_sources|sed -r 's/(\s+|\t+)/\r\n/g'|egrep "[Dd]ock|_USB_Advanced_Audio_Device")

## generate values for headset audio devices
headset_sink=$(echo $all_sinks|sed -r 's/(\s+|\t+)/\r\n/g'|egrep "[Hh]eadset")
headset_source=$(echo $all_sources|sed -r 's/(\s+|\t+)/\r\n/g'|egrep "[Hh]eadset")

## check if either recognized source exists, in priority order
if [[ -n $headset_sink ]]; then
  default_sink=$headset_sink
  default_source=$headset_source
elif [[ -n $dock_sink  ]]; then
  default_sink=$dock_sink
  #default_source=$dock_source
fi

pacmd set-default-sink $default_sink
pacmd set-default-source $default_source
