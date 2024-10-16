#!/bin/bash

ID="$(xinput list | grep -Eio '(Synaptics TM3072-003)\s*id\=[0-9]{1,2}' | awk '{print $NF}' | cut -d '=' -f 2)"
STATE="$(xinput list-props $ID|grep 'Device Enabled'|awk '{print $NF}')"
if [ $STATE -eq 1 ]
then
    xinput disable $ID
    echo "Touchpad disabled."
    notify-desktop 'Touchpad Disabled' -i /usr/share/icons/Adwaita/48x48/devices/input-touchpad.png
else
    xinput enable $ID
    echo "Touchpad enabled."
    notify-desktop 'Touchpad Enabled' -i /usr/share/icons/Adwaita/48x48/devices/input-touchpad.png
fi
