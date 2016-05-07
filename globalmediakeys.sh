#!/bin/bash

usage="$0 [toggle|prev|next]"

player_pid="$(pacmd list-sink-inputs|grep -E 'state|process.id'|grep -A1 "RUNNING"|grep -v "RUNNING"|awk -F '"' '{print $2}')"

## save player pid outside of this script for use later
if [[ $player_pid == "" ]]; then
  echo "no process found, using last known player"
  player_pid="$(cat /tmp/last_player)"
else
  echo "$player_pid" > /tmp/last_player
fi
#echo "player_pid is $player_pid"



prog=$(ps p $player_pid -o cmd|grep -v CMD)
#echo "prog is $prog"

## may need to add more cases in the event that other programs require
## special handling for media playback
case $prog in
  cmus)
    pause_cmd="cmus-remote -u"
    next_cmd="cmus-remote -n"
    prev_cmd="cmus-remote -r"
    ;;
  *)
    pause_cmd="XF86AudioPlay"
    next_cmd="XF86AudioNext"
    prev_cmd="XF86AudioPrev"
    ;;
esac

case $1 in
  toggle)
    action="$pause_cmd"
    ;;
  next)
    action="$next_cmd"
    ;;
  prev)
    action="$prev_cmd"
    ;;
  *)
    echo "$usage"
    exit 1
    ;;
esac

win_ids="$(wmctrl -l -p|grep $player_pid | awk '{print $1}'|head -1)"
#echo "win_ids is $win_ids"


if [[ $win_ids == "" ]]; then
  echo "No Window IDs associated, this program must be running without X"
  echo "Running \"$action\""
  $action
else
  current_window="$(xdotool getactivewindow)"
  echo "current_window is $current_window"
  xdotool windowactivate $win_ids
  xdotool key --clearmodifiers --window $win_ids $action
  xdotool windowactivate $current_window
fi
