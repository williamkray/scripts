#!/usr/bin/env bash
if [ -z "$1" ]; then
  echo "you must pass an output name, e.g. DP-3"
  exit 1
fi

/usr/lib/xdg-desktop-portal-wlr -r --output="$1" &
