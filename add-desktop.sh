#!/bin/bash
## quickie script to add or remove
## an extra virtual desktop
## to linux gui environment.

case "$1" in
  +)
    wmctrl -n $(($(wmctrl -d|wc -l) + 1 ))
    ;;
  -)
    wmctrl -n $(($(wmctrl -d|wc -l) - 1 ))
    ;;
  *)
    echo "usage: run \"`basename \"$0\"` [+|-]\" to either add or remove a desktop to the current configuration." 
esac
