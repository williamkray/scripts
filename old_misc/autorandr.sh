#!/bin/bash
## THIS SCRIPT IS DEPRECATED
## FUNCTIONALITY IS MOVED TO 
## auto-randr.sh, which is much simplified,
## as well as dock*.sh and undock.sh scripts
## audio is managed by auto-pulse.sh
#
# a better laid out version of my
# autrandr bash script, still in bash.
## do the needful
export DISPLAY=':0.0'
export PULSE_RUNTIME_PATH="/run/user/1000/pulse/"
#export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'
## start notification
notify-desktop "Starting autorandr" > /tmp/autorandr-id

## need to sleep a little to allow hardware changes to register
#sleep 5

## find all pulse audio sinks (speakers)
get_sinks() {
  all_sinks=$(pacmd list-sinks|grep 'name: <'|sed -r 's/(name: <|>)//g')
  #echo "Sinks found: $all_sinks"
}

## find all pulse audio sources (microphones)
get_sources() {
  all_sources=$(pacmd list-sources|grep 'name: <'|grep -v monitor|sed -r 's/(name: <|>)//g')
  #echo "Sources found: $all_sources"
}

get_ssids() {
  all_ssids=$(sudo iw dev wlp3s0 scan|grep "SSID: "|sed -r 's/\s+SSID:\s/ /g')
  #echo "SSIDs found: $all_ssids"
}

do_cmds() {
  for cmd in $@; do
    echo "Executing: $cmd"
    eval $cmd
  done
}

## determine some environmental factors
## get ssids first since it's slow
get_ssids
get_sinks
get_sources

## are we docked? check audio outputs
docked=false
if [[ $all_sinks =~ ([Dd]ock|_USB_Advanced_Audio_Device) ]]; then
  docked=true
fi

## where are we? use nearby wifi networks
if [[ -n $(echo $all_ssids|grep 'krayhome') ]]; then
  location='home'
elif [[ -n $(echo "$all_ssids"|grep 'TEN-Guest') ]]; then
  location='work'
else
  location='unrecognized'
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

## output some info so we know what's going on
echo "Location: $location"
echo "Docked: $docked"
echo "Audio output: $default_sink"
echo "Audio input: $default_source"
echo ""

## set some good general commands that can run

cmds_gen="numlockx
sudo dhcpcd eth0
sudo dhcpcd enp0s20u3u1u3
pacmd set-default-sink $default_sink
pacmd set-default-source $default_source
$del_if"

cmds_home="$cmds_gen
nice -n 19 ~/.screenlayout/home-docked.sh
xfce4-panel -r"

cmds_work="$cmds_home
"

IFS=$'\n'
if [[ $docked == true ]]; then
  if [[ $location == 'home' ]]; then
    do_cmds "$cmds_home"
  elif [[ $location == 'work' ]]; then
    do_cmds "$cmds_work"
  fi
else
  xrandr --auto
  /home/william/.scripts/scale.sh
  do_cmds "$cmds_gen"
  xfce4-panel -r
fi
unset IFS

## this one is for removing interfaces from
## resolvconf, but it's separate because
## it's a bit wordy

for i in $(resolvconf -i); do
  nic="${i/.dhcp/}"
  if [[ $(ip link show) =~ $nic ]]; then
    echo "interface $nic exists. skipping"
  else
    echo "removing nic $nic from resolvconf"
    sudo resolvconf -d "$i"
  fi
done

## adjust screen brightness depending on battery mode
if [[ $(cat /sys/class/power_supply/AC/online) == 1 ]]; then
  ~/.scripts/max
else
  ~/.scripts/mid
fi

notify-desktop -r $(cat /tmp/autorandr-id) "autorandr has run on display $DISPLAY"
