#!/bin/bash
## grabs laptop battery status and sends it to notifications on a linux desktop
bat=$(acpi|sed 's/\ 0\://g') && notify-send "$bat"
