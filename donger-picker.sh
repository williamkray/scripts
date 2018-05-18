#!/usr/bin/env bash
donger.sh show_all | rofi -dmenu | awk -F '|' '{print $2}'
