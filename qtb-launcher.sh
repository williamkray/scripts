#!/bin/bash

workspace=$(wmctrl -d | grep \* | awk '{print $NF}')

if [[ $workspace == "2" ]]; then
  qutebrowser --basedir ~/.qutebrowser/corpinfo $@
elif [[ $workspace == "4" ]]; then
  qutebrowser --basedir ~/.qutebrowser/beachbody $@
else
  qutebrowser --basedir ~/.qutebrowser/weck $@
fi
