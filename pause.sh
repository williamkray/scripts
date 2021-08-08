#!/usr/bin/env bash

set -e

## pause lockscreen and notifications

touch ~/.pause

echo -n 'PAUSED' > ~/.pause
while [[ -s ~/.pause ]]; do
  xautolock -disable
  dunstctl set-paused true

  read -p $'Screenlock and notifications paused. Press enter to re-enable...\n\n'
  echo -n '' > ~/.pause
done

xautolock -enable
dunstctl set-paused false

echo "Screenlock and notifications re-enabled."
