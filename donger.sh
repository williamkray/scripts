#!/bin/bash
arg="$@"
dmenu_cmd="rofi -dmenu"

dongerlist='glare | ಠ_ಠ
blank | ರ_ರ
creep | ಠ‿ಠ
shrug | ¯\\_(ツ)_/¯
heyho | ヽ(⌐■_■)ノ♪♬
flip | (╯°□°)╯︵ ┻━┻
unflip | ┬─┬ノ(ಠ_ಠノ)
skank | ᕕ(⌐■_■)ᕗ ♪♬
monacle | (╭ರ_•́)
coolcool | (⌐ ͡■ ͜ʖ ͡■)'

usage="Usage:
$(basename $0) [ls|cp|wrap]

  use ls or list to show output of the donger list
  use cp or copy to copy the donger version of that output

  * the cp/copy command expects the format of a line from the donger list. be sure to pipe that output into the copy
    command to ensure the proper characters are copied to the clipboard. this script is meant to be run with a
    dmenu-like helper, like so:

  $(basename $0) ls | dmenu | $(basename $0) cp

  in fact, using the wrap command does exactly that: wraps the above command."

case $arg in
  ls|list)
    echo "$dongerlist"
    ;;
  cp|copy)
    read input
    donger="$(echo -n "$input" | cut -d' ' -f3-)"
    echo -n "$donger" | xclip -i -selection clipboard
    dunstify "dongers" "$donger copied to clipboard"
    ;;
  wrap)
    $0 list | $dmenu_cmd | $0 copy
    ;;
  *)
    echo "$usage"
esac
