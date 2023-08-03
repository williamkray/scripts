#!/usr/bin/bash
set -x
state_file=$(find /proc/acpi/button/lid/LID*/state)
if grep -q open ${state_file}; then
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
else
    mon_count=$(hyprctl -j monitors | jq '. | length')
    if [[ $mon_count -gt 1 ]]; then
        hyprctl keyword monitor "eDP-1,disable"
    else # lid closed and only one monitor? check to make sure it's not the built in!
        if [[ $(hyprctl -j monitors | jq -r '.[].name') == 'eDP-1' ]]; then
            exit 0
        else
            hyprctl keyword monitor "eDP-1,disable"
        fi
    fi
fi
