#!/bin/bash
name="$1"

case $name in
  glare | 'ಠ_ಠ' )
    donger="ಠ_ಠ";;
  blank | 'ರ_ರ' )
    donger="ರ_ರ";;
  creep| 'ಠ‿ಠ' )
    donger="ಠ‿ಠ";;
  shrug | '¯\_(ツ)_/¯' )
    donger='¯\_(ツ)_/¯';;
  heyho | 'ヽ(⌐■_■)ノ♪♬' )
    donger='ヽ(⌐■_■)ノ♪♬';;
  flip | '(╯°□°)╯︵ ┻━┻' )
    donger='(╯°□°)╯︵ ┻━┻';;
  unflip | '┬─┬ノ(ಠ_ಠノ)' )
    donger='┬─┬ノ(ಠ_ಠノ)';;
  skank|'ᕕ(⌐■_■)ᕗ ♪♬')
    donger='ᕕ(⌐■_■)ᕗ ♪♬';;
  monacle|'(╭ರ_•́)')
    donger='(╭ರ_•́)';;
  coolcool|'(⌐ ͡■ ͜ʖ ͡■)')
    donger='(⌐ ͡■ ͜ʖ ͡■)';;
  show_names)
    echo "glare 
blank 
creep 
shrug 
heyho 
flip 
unflip 
skank 
monacle 
coolcool"
    exit 0
    ;;
  show_all)
    echo "glare | ಠ_ಠ
blank | ರ_ರ
creep| ಠ‿ಠ
shrug | ¯\_(ツ)_/¯
heyho | ヽ(⌐■_■)ノ♪♬
flip | (╯°□°)╯︵ ┻━┻
unflip | ┬─┬ノ(ಠ_ಠノ)
skank | ᕕ(⌐■_■)ᕗ ♪♬
monacle | (╭ರ_•́)
coolcool | (⌐ ͡■ ͜ʖ ͡■)"
  exit 0
  ;;
  show_dongers)
    echo "ಠ_ಠ
ರ_ರ
ಠ‿ಠ
¯\_(ツ)_/¯
ヽ(⌐■_■)ノ♪♬
(╯°□°)╯︵ ┻━┻
┬─┬ノ(ಠ_ಠノ)
ᕕ(⌐■_■)ᕗ ♪♬
(╭ರ_•́)
(⌐ ͡■ ͜ʖ ͡■)"
  exit 0
  ;;
  *)
    echo "you doin it wrong"
    exit 1
    ;;
esac

echo -n "$donger" | xclip -i -selection clipboard
sleep 0.2
xdotool key ctrl+v
