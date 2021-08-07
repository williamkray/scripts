#!/usr/bin/env bash

set -e

## pause lockscreen and notifications

xautolock -disable
dunstctl set-paused true

read -p "Screenlock and notifications paused. Press enter to re-enable..."

xautolock -enable
dunstctl set-paused false

echo "Screenlock and notifications re-enabled."
