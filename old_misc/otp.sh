#!/bin/bash
set -e

oathtool -b --totp "$1" | xclip -i -selection clipboard

msg="One Time Password copied to clipboard!"
echo "$msg" && notify-desktop "$msg"
