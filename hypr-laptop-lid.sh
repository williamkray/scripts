#!/usr/bin/bash
set -x
state_file=$(find /proc/acpi/button/lid/LID*/state)
if grep -q open ${state_file}; then
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
else
    mon_count=$(hyprctl -j monitors | jq '. | length')
    echo $mon_count > /tmp/mon_count
    if [[ $mon_count -gt 1 ]]; then
        hyprctl keyword monitor "eDP-1,disable"
    else
        return 0
    fi
fi
