#!/usr/bin/env bash

set -e

## pause lockscreen and notifications
file=~/.pause
touch "$file"

_unpause() {
  if [[ "$XDG_CURRENT_DESKTOP" = "sway" || "$XDG_CURRENT_DESKTOP" = "Hyprland" ]]; then
    if [ -z $(pidof swayidle) ]; then
      swayidle.sh
    fi
  else
    xautolock -enable
    cmd=$(grep xautolock ~/.xinitrc)
    eval $cmd
    xset +dpms
  fi

  dunstctl set-paused false
  echo '' > "$file"
  echo "Screenlock and notifications unpaused."
}

_pause() {
  if [[ "$XDG_CURRENT_DESKTOP" = "sway" || "$XDG_CURRENT_DESKTOP" = "Hyprland" ]]; then
    kill $(pidof swayidle)
  else
    xautolock -disable
    echo 'PAUSE' > "$file"
    kill $(pidof xautolock)
    xset -dpms
  fi

  dunstctl set-paused true
  echo 'PAUSE' > "$file"
  echo "Screenlock and notifications paused. Run this script again to unpause."
}

if [[ -f "$file" && -z $(cat "$file") ]]; then
  _pause
else
  _unpause
fi

