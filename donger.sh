#!/bin/bash
name="$1"

case $name in
  glare)
    donger="ಠ_ಠ";;
  blank)
    donger="ರ_ರ";;
  creep)
    donger="ಠ‿ಠ";;
  shrug)
    donger='¯\_(ツ)_/¯';;
  heyho)
    donger='ヽ(⌐■_■)ノ♪♬';;
  flip)
    donger='(╯°□°)╯︵ ┻━┻';;
  unflip)
    donger='┬─┬ノ(ಠ_ಠノ)';;
  skank)
    donger='ᕕ(⌐■_■)ᕗ ♪♬';;
  monacle)
    donger='(╭ರ_•́)';;
  coolcool)
    donger='(⌐ ͡■ ͜ʖ ͡■)';;
  *)
    echo "glare blank creep shrug heyho flip unflip skank monacle coolcool"
    exit 0
    ;;
esac

echo -n "$donger" | xclip -i -selection clipboard
sleep 0.2
xdotool key ctrl+v
