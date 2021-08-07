#!/usr/bin/env bash

## a rewrite of my previous tmux scripts because they are terrible
## this script ensures that any commands passed to it are run in a window of an existing tmux session, allowing you to
## use it to launch by default with your terminal emulator and have everything you run safely backgrounded

## you can expand upon special use cases by adding more functions


## define TMUX_MASTER here. this is the name of the tmux session that everything is attached to.
## it can be anything you want, really.
TMUX_MASTER=tmux-zero

## find any existing tmux sessions
## if no sessions exist, a TMUX_MASTER session will be created
sessions=`tmux ls | grep $TMUX_MASTER | awk -F ':' '{print $1}'`

## set a default argument (start a shell session) if no command is specified
if [[ -z "$@" ]]; then
  input=$SHELL
else
  input="$@"
fi

## get the program used in the command, in case it matches a special use case
prog="$(echo "$input"|awk '{print $1}')"

#debug
#echo "sessions:"
#echo "$sessions"
#echo "input:"
#echo "$input"
#echo "prog:"
#echo "$prog"

## define a few helper functions
create_master_session() {
  #debug
  echo "arg:"
  echo "$@"
  tmux new -s $TMUX_MASTER "$@"
}

create_unnamed_window() {
  #debug
  echo "arg:"
  echo "$@"
  ## account for nonexisting master session
  if [[ -z "$sessions" ]]; then
    echo "no session found, need to start one"
    tmux_args="new -s $TMUX_MASTER"
  else
    tmux_args="attach-session -t $TMUX_MASTER"
  fi
  tmux $tmux_args \; new-window "$@"
}

create_named_window() {
  ## different in that it expects the first word to be a name
  command=$(echo "$@" | cut -d' ' -f2-)
  #debug
  echo "arg:"
  echo "$@"
  echo '$1:'
  echo "$1"
  echo "command:"
  echo "$command"
  ## account for nonexisting master session
  if [[ -z "$sessions" ]]; then
    echo "no session found, need to start one"
    tmux_args="new -s $TMUX_MASTER"
  else
    tmux_args="attach-session -t $TMUX_MASTER"
  fi
  tmux $tmux_args \; new-window -n "$1" $command
}

attach_existing_window() {
  #debug
  echo "arg:"
  tmux attach-session -t $TMUX_MASTER \; select-window -t "$1"
}

## the meat of the matter
# default to creating an unnamed window
func="create_unnamed_window"

case $prog in
  cmus)
    #debug
    echo "cmus identified"
    name='C*Mus'
    if [[ -z "$(tmux list-windows -t $TMUX_MASTER | grep $name)" ]]; then
      func="create_named_window"
      #debug
      echo "creating new named window"
      $func 'C*Mus' cmus
    else
      func="attach_existing_window"
      #debug
      echo "attaching to existing $name window"
      $func "$name"
    fi
    ;;
  *)
    #debug
    echo "unidentified program"
    echo "creating unnamed window"
    $func $input
    ;;
esac

