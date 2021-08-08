#!/usr/bin/env bash

set -e

## pause lockscreen and notifications

touch ~/.pause

_unpause() {
  xautolock -enable
  dunstctl set-paused false
  echo '' > ~/.pause
  echo "Screenlock and notifications unpaused."
}

_pause() {
  echo 'PAUSED' > ~/.pause
  xautolock -disable
  dunstctl set-paused true
  echo "Screenlock and notifications paused. Run this script again to unpause."
}

if [[ -f ~/.pause && -z $(cat ~/.pause) ]]; then
  _pause
else
  _unpause
fi

