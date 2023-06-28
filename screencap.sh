#!/usr/bin/env bash

wutcap="$1"

if [[ -z $wutcap ]]; then
  wutcap="some"
fi

if [[ $XDG_CURRENT_DESKTOP = "sway" || $XDG_CURRENT_DESKTOP = "Hyprland" ]]; then
  cmd=grimshot
elif [[ $(which maim) ]]; then
  cmd=maim
elif [[ $(which scrot) ]]; then
  cmd=scrot
elif [[ $(which gnome-screenshot) ]]; then
  cmd=gnome-screenshot
else
  echo "no screencap app found, exiting"
  exit 1
fi

mkdir -p /tmp/screenshots

case $cmd in 
  grimshot)
    if [ "$(pidof slurp)" ]; then
      kill $(pidof slurp) # kill the process if it's already launched
      exit 0
    fi
    case $wutcap in
      some)
        flags=" --notify copy area"
        ;;
      all)
        flags=" --notify save screen /tmp/screenshots/Screenshot_$(date +%Y%m%d%H%M%S).png"
        ;;
      lock)
        flags=" save screen /tmp/lock.png"
        ;;
    esac
    ;;
  maim )
    case $wutcap in
      some)
        flags=" --select /tmp/screenshots/Screenshot_$(date +%Y%m%d%H%M%S).png"
        ;;
      all)
        flags=" /tmp/screenshots/Screenshot_$(date +%Y%m%d%H%M%S).png"
        ;;
      lock)
        flags=" /tmp/lock.png"
    esac
    ;;
  scrot)
    case $wutcap in
      some)
        flags=" --select /tmp/screenshots/Screenshot_%Y%m%d%H%M%S.png"
        ;;
      all)
        flags=" /tmp/screenshots/Screenshot_%Y%m%d%H%M%S.png"
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

if ! [[ $XDG_CURRENT_DESKTOP = "sway" ]]; then
  cat "$(ls -1tr /tmp/screenshots/Screenshot_* | tail -1)" | xclip -selection clipboard -i -t image/png
fi
