#!/bin/bash

workspace=$(wmctrl -d | grep \* | awk '{print $NF}')

if [[ $workspace == "Q4" ]]; then
  google-chrome-stable --profile-directory="Profile 4"
elif [[ $workspace == "Opsflo" ]]; then
  google-chrome-stable --profile-directory="Profile 2"
else
  google-chrome-stable --profile-directory="Profile 3"
fi
