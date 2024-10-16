#!/usr/bin/env bash

feh --scale-down \
  --draw-tinted \
  --action1 ';[Copy file name to clipboard]echo -n %N | xclip -in -selection clipboard && dunstify "feh" "image name copied to clipboard"' \
  --action2 ';[Copy file path to clipboard]echo -n %F | xclip -in -selection clipboard && dunstify "feh" "image file path copied to clipboard"' \
  --action ';[Copy file content to clipboard]xclip -in -selection clipboard -t image/png %F && dunstify "feh" "image copied to clipboard"' \
  --draw-actions  \
  --conversion-timeout 5 \
  --start-at $@
