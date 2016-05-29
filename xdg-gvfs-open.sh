#!/bin/bash

## profile script to force xdg-open to use gnome environment settings

alias xdg-open='XDG_CURRENT_DESKTOP="GNOME" /usr/bin/xdg-open'
