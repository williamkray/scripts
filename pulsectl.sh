#!/bin/bash
if grep -i arguments /tmp/vol ; then
  rm /tmp/vol
fi


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

master=$(amixer get Master|grep 'Front Left:')
vol=$(echo "$master" | awk '{print $5}'|tr -d "[|]|%")
state=$(amixer get Master|grep 'Front Left:'|awk '{print $6}'|tr -d "[|]|%")

if [[ $state == "on" ]]; then
  if (( "$vol" <= 10)); then
    icon="notification-audio-volume-low"
  elif (( "$vol" <= 60 && "$vol" > 10)); then
    icon="notification-audio-volume-medium"
  elif (( "$vol" <= 100 && "$vol" > 60)); then
    icon="notification-audio-volume-high"
  else
    echo "volume can't be found!"
  fi
  vol="$vol%"
else
  ## hack in a persistent notification if muted
  icon="notification-audio-volume-muted -t 0"
  vol="MUTE"
fi

if [ -f /tmp/vol ]; then
  r="-r $(cat /tmp/vol)"
fi

cmd="notify-desktop $r -i $icon Volume $vol"
echo "$cmd"
$cmd > /tmp/vol
