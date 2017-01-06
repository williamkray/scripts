#!/usr/bin/env bash
## attempts to autofill input from
## password-store data in text fields
## based on the window title
set -e

## first of all, you must run this script
## with either the a or o argument
usage="usage: $0 <a|o> \n
  a autofill username and password according to pattern \n
  o capture and enter time-based otp"

if [ ! "$1" == "a" ] && [ ! "$1" == "o" ]; then
  echo -e $usage
  exit
fi

## figure out where we store our passwords
if [ "X$PASSWORD_STORE_DIR" == "X" ]; then
  password_store_dir="$HOME/.password-store"
else
  password_store_dir="$PASSWORD_STORE_DIR"
fi

## here we get into some really hideous sanitization
## and tracking of linux window titles
window="$(xdotool getwindowfocus getwindowname)"
## sanitize forwardslashes which cause problems
window="${window/\//_}"
## strip browser id out if it's a browser window
## this should make it work across any browsers that
## are added to this simple regex
if [[ $window =~ (Mozilla|Chrome|Chromium) ]]; then
  window="$(echo ${window// /_}|awk -F '-' '{$NF=""; print $0}')"
  ## replace stripped out hyphens we had before
  window="$(echo ${window// /-})"
fi

## set the path for the file associated with this window name
af_dir="$password_store_dir/.autofill/$window"

## if we don't already have a file that matches our window,
## we get an opportunity to create one right now in
## our favorite editor
if ! [ -f $af_dir ]; then
  echo "no such auto-fill entry"
  echo "creating a new one"
  urxvt -e vim "$af_dir"
fi

## the file should contain the pass path to the
## proper secret file
path="$(grep path $password_store_dir/.autofill/$window |awk '{print $2}')"
## if there are more than one path available,
## open a picker to select the proper one
if [ $(echo "$path"|wc -l) -gt 1 ]; then
  multipath=$(yad --center \
    --title "Pass Picker" \
    --image "keepassx" \
    --text "Select which password file to use" \
    --form --item-separator="\n" \
    --field="Possible paths":CB \
    "$path")
  path=$(echo $multipath|awk -F '|' '{print $1}')
fi

## just do otp
if [ "$1" == "o" ]; then
  pass otp $path
  xdotool key "ctrl+v"
  xdotool key Return
## do all the things
elif [ "$1" == "a" ]; then
  ## there may be window-specific patterns here
  pattern="$(grep pattern $password_store_dir/.autofill/$window|awk '{$1=""; print $0}')"

  if [ "X$(pass $path|grep -v pattern|grep username)" == "X" ]; then
    username="$(echo $path|awk -F '/' '{print $NF}')"
  else
    username="$(pass $path|grep -v pattern|grep username|awk '{print $2}')"
  fi
  password="$(pass $path|head -1)"

  ## only reset pattern if it hasn't been set
  if [ "X$pattern" == "X" ]; then
    pattern=$( pass $path|grep pattern|awk '{$1=""; print $0}')
  fi

  ## and again, default to something sensible
  if [ "X$pattern" == "X" ]; then
    pattern="username tab password enter"
  fi

  ## and last time, because i keep typing enter instead of return
  pattern="${pattern//enter/return}"

  for step in $pattern ; do
    echo "processing $step"
    case $step in
      return|tab)
        xdotool key ${step^}
        ;;
      username|password)
        xdotool type "${!step}"
        ;;
      sleep*)
        sleep ${step#sleep}
        ;;
      pin)
        xdotool type "$(pass $path|grep $step|awk '{print $2}')"
        ;;
      *)
        echo "i don't know what to do"
        ;;
    esac
  done

else
  echo "unrecognized argument. goodbye"
  exit 1
fi
