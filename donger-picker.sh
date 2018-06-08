#!/usr/bin/env bash
donger.sh show_all | rofi -dmenu | awk -F '|' '{printf $2}' | xclip -i -selection clipboard && sleep 0.2 && xdotool key ctrl+v
