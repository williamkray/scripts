#!/bin/bash

workspace=$(wmctrl -d | grep \* | awk '{print $NF}')

if [[ $workspace == "Q4" ]]; then
  chromium --profile-directory="Profile 4"
elif [[ $workspace == "Opsflo" ]]; then
  chromium --profile-directory="Profile 2"
else
  chromium --profile-directory="Profile 3"
fi
