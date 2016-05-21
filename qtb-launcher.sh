#!/bin/bash

workspace=$(wmctrl -d | grep \* | awk '{print $NF}')

if [[ $workspace == "W" ]]; then
  qutebrowser --basedir ~/.qutebrowser/corpinfo $@
else
  qutebrowser $@
fi
