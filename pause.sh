#!/usr/bin/env bash

set -e

## pause lockscreen and notifications
file=~/.pause
touch "$file"

_unpause() {
  xautolock -enable
  dunstctl set-paused false
  echo '' > "$file"
  echo "Screenlock and notifications unpaused."
}

_pause() {
  echo 'PAUSE' > "$file"
  xautolock -disable
  dunstctl set-paused true
  echo "Screenlock and notifications paused. Run this script again to unpause."
}

if [[ -f "$file" && -z $(cat "$file") ]]; then
  _pause
else
  _unpause
fi

