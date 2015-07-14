#!/bin/bash

input="$1"

sessions=`tmux ls|awk -F ':' '{print $1}'`
detached_sessions=`tmux ls | grep -v attached | awk -F ':' '{print $1}' | egrep -v ^$TMUX_MASTER`

if [[ -z $1 ]]; then
  input='bash'
fi

if [[ -z $sessions ]]; then
  if [[ "$1" == "cmus" ]]; then
    tmux -2 new -s $TMUX_MASTER \; new-window -t 0 -n CMus "cd ~/Playlists && cmus"
    cmus-remote -l /home/william/Music
    cmus-remote -C "update-cache"
  elif [[ "$1" == "ssh" ]]; then
    source /tmp/s
    HOST="${URL:6}"
    hostonly=`echo $HOST | sed 's/^.*\@//'`
    tmux -2 new-session -s "$TMUX_MASTER" -n "$hostonly" "~/Scripts/s $HOST -t" \; split-window -v "~/Scripts/s $HOST"
  else
    tmux -2 new -s $TMUX_MASTER "$input"
  fi
else
  for s in $detached_sessions; do
    tmux kill-session -t "$s"
  done
  if [[ "$1" == "cmus" ]]; then
    # run cmus as a special case
    if [[ -z $(pidof cmus) ]]; then
      tmux -2 new -t $TMUX_MASTER \; new-window -t 0 -n CMus "cd ~/Playlists && cmus"
      cmus-remote -l /home/william/Music
      cmus-remote -C "update-cache"
    else
      tmux -2 new -t $TMUX_MASTER \; select-window -t CMus
      cmus-remote -l /home/william/Music
      cmus-remote -C "update-cache"
    fi
  elif [[ "$1" == "ssh" ]]; then
    source /tmp/s
    HOST="${URL:6}"
    hostonly=`echo $HOST | sed 's/^.*\@//'`
    tmux -2 new-session -t "$TMUX_MASTER" \; new-window -n "$hostonly" "~/Scripts/s $HOST -t" \; split-window -v "~/Scripts/s $HOST"
  else
  tmux -2 new -t $TMUX_MASTER \; new-window "$input"
  fi
fi
