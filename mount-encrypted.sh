#!/usr/bin/env bash

device="$1"
mapname="${device//\//}"
cryptsetup open "$device" "$mapname"
mount "/dev/mapper/$mapname" /mnt/
