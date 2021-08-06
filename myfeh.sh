#!/usr/bin/env bash

feh --scale-down \
  --draw-tinted \
  --action ';[Copy file name to clipboard]echo -n %N | xclip -in -selection clipboard && dunstify "feh" "image name copied to clipboard"' \
  --draw-actions  \
  --conversion-timeout 5 \
  --start-at $@
