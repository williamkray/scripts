#!/usr/bin/env bash

wutcap="$1"

if [[ -z $wutcap ]]; then
  wutcap="some"
fi

if [[ $(which maim) ]]; then
  cmd=maim
elif [[ $(which scrot) ]]; then
  cmd=scrot
elif [[ $(which gnome-screenshot) ]]; then
  cmd=gnome-screenshot
else
  echo "no screencap app found, exiting"
  exit 1
fi

case $cmd in 
  maim )
    case $wutcap in
      some)
        flags=" --select /tmp/Screenshot_$(date +%Y%m%d%H%M%S).png"
        ;;
      all)
        flags=" /tmp/Screenshot_$(date +%Y%m%d%H%M%S).png"
        ;;
      lock)
        flags=" /tmp/lock.png"
    esac
    ;;
  scrot)
    case $wutcap in
      some)
        flags=" --select /tmp/Screenshot_%Y%m%d%H%M%S.png"
        ;;
      all)
        flags=" /tmp/Screenshot_%Y%m%d%H%M%S.png"
        ;;
      lock)
        flags=" -o /tmp/lock.png"
    esac
    ;;
  gnome-screenshot)
    flags=" --interactive"
esac

echo "executing $cmd $flags"
$cmd $flags
echo "$(ls -1tr /tmp/Screenshot_* | tail -1)" | xclip -selection clipboard -i
