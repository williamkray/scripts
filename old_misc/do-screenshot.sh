#!/bin/bash
## deprecated, use screencap.sh instead

function get_file {
	last_file=$(ls -t ~/Pictures/Screenshots/|head -1)
}

prefix="/home/william/Pictures/Screenshots"

if [ $# -eq 0 ]; then
	echo "usage: must include -r for region, -f for full-screen, or -w for window"
	exit
fi

xfce4-screenshooter "$1" -s "$prefix"

if [[ $? == 0 ]]; then
	get_file
	new_name=`echo "$last_file" | sed 's/\://g'`
	mv "$prefix"/"$last_file" "$prefix"/"$new_name"
else
	exit
fi
