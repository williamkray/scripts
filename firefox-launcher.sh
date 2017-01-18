#!/bin/bash

workspace=$(wmctrl -d | grep \* | awk '{print $NF}')

if [[ $workspace == "2" ]]; then
  firefox -P corpinfo $@
elif [[ $workspace == "4" ]]; then
  firefox -P beachbody $@
else
  firefox -P default $@
fi
