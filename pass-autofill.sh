#!/usr/bin/env bash
## attempts to autofill input from
## password-store data in text fields
## based on the window title
set -e

password_store_dir=$( [ $PASSWORD_STORE_DIR ] && echo $PASSWORD_STORE_DIR || echo "$HOME/.password-store" )

## we need to have a consistent naming scheme that works
window="$(xdotool getwindowfocus getwindowname)"
## strip browser out if it's a browser window
if [[ $window =~ (Mozilla|Chrome|Chromium) ]]; then
  window="$(echo ${window// /_}|awk -F '-' '{$NF=""; print $0}')"
  ## replace stripped out hyphens we had before
  window="$(echo ${window// /-})"
fi

af_dir="$password_store_dir/.autofill/$window"

if ! [ -f $af_dir ]; then
  echo "no such auto-fill entry"
  echo "creating an empty one"
  ## i open my editor with my favorite script here
  ## but this could be anything you want to do
  urxvt -e vim "$af_dir"
fi

## the file should contain the pass path to the
## proper secret file
path=$(head -1 $password_store_dir/.autofill/$window)
## there may be window-specific patterns here
pattern="$(grep pattern $password_store_dir/.autofill/$window|awk '{$1=""; print $0}')"

out="$(pass $path)"
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
pattern="${pattern/enter/return}"

for step in $pattern ; do
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
    *)
      echo "i don't know what to do"
      ;;
  esac
done

