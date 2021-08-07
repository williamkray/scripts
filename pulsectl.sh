#!/bin/bash

case "$1" in
  up)
    amixer -D pulse set Master 2%+ unmute
    ;;
  down)
    amixer -D pulse set Master 2%- unmute
    ;;
  toggle)
    amixer -D pulse set Master toggle
esac

master=$(amixer get Master|grep 'Front Left:')
vol=$(echo "$master" | awk '{print $5}'|tr -d "[|]|%")
state=$(amixer get Master|grep 'Front Left:'|awk '{print $6}'|tr -d "[|]|%")

if [[ $state == "on" ]]; then
  if (( "$vol" <= 10)); then
    icon="audio-volume-low"
  elif (( "$vol" <= 60 && "$vol" > 10)); then
    icon="audio-volume-medium"
  elif (( "$vol" <= 100 && "$vol" > 60)); then
    icon="audio-volume-high"
  else
    echo "volume can't be found!"
  fi
  vol="$vol%"
else
  ## get rid of the hacked in persistent notification
  icon="audio-volume-muted"
  vol="MUTE"
fi

if [ -f /tmp/vol ]; then
  r="-r $(cat /tmp/vol)"
fi

cmd="dunstify -h string:x-dunst-stack-tag:volume -h int:value:$vol -i $icon Volume $vol"
echo "$cmd"
$cmd #> /tmp/vol
canberra-gtk-play -i audio-volume-change -d "changeVolume"
