!#/bin/bash

# change volue on laptop speakers
case "$1" in
  up)
    amixer -c 0 set Master 5%+ unmute
    ;;
  down)
    amixer -c 0 set Master 5%- unmute
    ;;
  toggle)
    amixer -c 0 set Master toggle
esac

# change volume on docking station
if [[ -n $(aplay -l | grep "card 2" ) ]]; then
  case "$1" in
    up)
      amixer -c 2 set PCM 5%+ unmute
      ;;
    down)
      amixer -c 2 set PCM 5%- unmute
      ;;
    toggle)
      amixer -c 2 set PCM toggle
  esac
fi
