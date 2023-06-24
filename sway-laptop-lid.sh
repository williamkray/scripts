#!/usr/bin/bash
set -x
state_file=$(find /proc/acpi/button/lid/LID*/state)
if grep -q open ${state_file}; then
    swaymsg output eDP-1 enable
else
    swaymsg output eDP-1 disable
fi
