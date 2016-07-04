#!/bin/bash

mymode="$(cvt 1920 1080|tail -1|cut -d" " -f3-)"
cmd="xrandr --newmode "1920x1080_60.00" $mymode"
echo $cmd
$cmd
cmd="xrandr --addmode eDP-1 1920x1080_60.00"
echo $cmd
$cmd
cmd="xrandr --output eDP-1 --mode 1920x1080_60.00"
echo $cmd
$cmd
