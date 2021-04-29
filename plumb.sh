#!/usr/bin/env bash

filetype="$(xdg-mime query filetype $@)"
echo "filetype is $filetype"
xdg-mime query default $filetype
xdg-open $@ &
