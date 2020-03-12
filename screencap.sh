#!/usr/bin/env bash

wutcap="$1"

if [[ -z $wutcap ]]; then
  echo "you must supply an argument of either 'some' or 'all' to this script. figguritout."
  exit 1
fi

if [[ $(which escrotum) ]]; then
  cmd=escrotum
elif [[ $(which scrot) ]]; then
  cmd=scrot
elif [[ $(which gnome-screenshot) ]]; then
  cmd=gnome-screenshot
else
  echo "no screencap app found, exiting"
  exit 1
fi

case $cmd in 
  escrotum | scrot)
    case $wutcap in
      some)
        flags=" --select /tmp/Screenshot_%Y%m%d%H%M%S.png"
        ;;
      all)
        flags=" /tmp/Screenshot_%Y%m%d%H%M%S.png"
        ;;
      lock)
        flags=" /tmp/lock.png"
    esac
    ;;
  gnome-screenshot)
    flags=" --interactive"
esac

echo "executing $cmd $flags"
$cmd $flags
