#!/usr/bin/bash
set -x
state_file=$(find /proc/acpi/button/lid/LID*/state)
if grep -q open ${state_file}; then
    hyprctl keyword monitor "eDP-1,preferred,auto,auto"
else
    hyprctl keyword monitor "eDP-1,disable"
fi
