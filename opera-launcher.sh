#!/bin/bash

workspace=$(wmctrl -d | grep \* | awk '{print $NF}')

if [[ $workspace == "2" ]]; then
  opera --user-data-dir=/home/william/.opera/corpinfo $@
elif [[ $workspace == "4" ]]; then
  opera --user-data-dir=/home/william/.opera/beachbody $@
else
  opera --user-data-dir=/home/william/.opera/weck $@
fi
