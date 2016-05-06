#!/bin/bash

workspace=$(wmctrl -d | grep \* | awk '{print $NF}')

if [[ $workspace == "W" ]]; then
  google-chrome-stable --profile-directory="Profile 5"
elif [[ $workspace == "S" ]]; then
  google-chrome-stable --profile-directory="Profile 2"
else
  google-chrome-stable --profile-directory="Profile 3"
fi
