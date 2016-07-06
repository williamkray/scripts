#!/bin/bash

mymode="$(cvt 1920 1080|tail -1|cut -d" " -f3-)"
cmd="xrandr --newmode 1920x1080 $mymode"
echo $cmd
$cmd
cmd="xrandr --addmode eDP1 1920x1080"
echo $cmd
$cmd
cmd="xrandr --output eDP1 --mode 1920x1080"
echo $cmd
$cmd
