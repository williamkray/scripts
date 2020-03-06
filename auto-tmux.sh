#!/bin/bash
## this script is used to launch all terminal sessions
## within an existing tmux session. It looks for a master session
## whose name is set as an environment variable, so
## be sure to add that to your bash profile.
## it also handles killing detached sessions on each launch,
## so that you don't end up with a million tmux sessions because
## you closed several terminal windows.


## There are also bits in here that make use of some other scripts
## to run cmus on window 0, rename SSH sessions, etc.
## otherwise, it can also take an argument to launch with.
## this pretty much depends heavily on having your terminal and other 
## scripts already in your path and well configured.

## I would like to apologize for the complexity of this,
## it started very simply and I just don't have the energy to properly
## break out the bits that should be functions. Besides,
## each use case is slightly unique, which makes it a little weird.

## define TMUX_MASTER here instead of bash profile or something silly
TMUX_MASTER=tmux-zero
## separate value to launch a command
input="$@"

## find any existing tmux sessions
sessions=`tmux ls|awk -F ':' '{print $1}'`
detached_sessions=`tmux ls | grep -Ev '(attached|tmux-master:)' | awk -F ':' '{print $1}'`

## define a logical default command to run
if [[ -z $input ]]; then
  input=$SHELL
fi

## add the detach command so we don't have
## a ton of random terminals open all the time
#input="$input && tmux detach"

## get the first word of the command, used later
cmd=`echo "$input"|awk '{print $1}'`

## start up a new master if this is the first go
## taking into account what the first command to start with is
if [[ -z $sessions ]]; then
  if [[ "$1" == "cmus" ]]; then
    ## force a remount of my sshfs mount because network things are dumb
    ## and then start cmus detached so we background it
    ## then update the library and cache,
    ## and reattach. sleep keeps cmus-remote from throwing errors.
    #~/.scripts/musicmount.sh && \
      tmux -2 new -s $TMUX_MASTER \; new-window -t 0 -n CMus "cd ~/Music/playlists && cmus && tmux detach" \; detach-client && \
      sleep 1 && \
      cmus-remote -l /home/william/Music/contemporary && \
      cmus-remote -C "update-cache"
    tmux -2 new -t $TMUX_MASTER \; select-window -t CMus
  ## if the first command was ssh, we need to get variables from
  ## the temp file generated by our special 's' script
  elif [[ "$1" == "ssh" ]]; then
    source /tmp/s
    HOST="${URL:6}"
    hostonly=`echo $HOST | sed 's/^.*\@//'`
    tmux -2 new-session -s "$TMUX_MASTER" -n "$hostonly" "~/.scripts/s $HOST -t" \; split-window -v "~/.scripts/s $HOST"
  else
    ## ssh and cmus are the only special cases,
    ## anything else should start without problems
    tmux -2 new -s $TMUX_MASTER "$input"
  fi
else
  ## if there are existing tmux sessions,
  ## let's do a little housecleaning
  for s in $detached_sessions; do
    tmux kill-session -t "$s"
  done
  ## if cmus is running, attach to that window,
  ## otherwise we'll do the needful and start it up
  ## but every time we want to remount that sshfs folder
  if [[ "$1" == "cmus" ]]; then
    # run cmus as a special case
    if [[ -z $(pidof cmus) ]]; then
      #~/.scripts/musicmount.sh && \
        tmux -2 new -t $TMUX_MASTER \; new-window -t 0 -n CMus "cd ~/Music/playlists && cmus && tmux detach" \; detach-client && \
        sleep 1 && \
        cmus-remote -l /home/william/Music/contemporary && \
        cmus-remote -C "update-cache"
      tmux -2 new -t $TMUX_MASTER \; select-window -t CMus
    else
      #~/.scripts/musicmount.sh && \
        cmus-remote -l /home/william/Music/contemporary && \
        cmus-remote -C "update-cache"
      tmux -2 new -t $TMUX_MASTER \; select-window -t CMus
    fi
  ## if ssh was the argument, grab those external variables
  elif [[ "$1" == "ssh" ]]; then
    source /tmp/s
    HOST="${URL:6}"
    hostonly=`echo $HOST | sed 's/^.*\@//'`
    tmux -2 new-session -t "$TMUX_MASTER" \; new-window -n "$hostonly" "~/.scripts/s $HOST -t" \; split-window -v "~/.scripts/s $HOST"
  ## cmus and ssh were the only special cases,
  ## if nothing was passed as an argument then it's just "bash"
  ## otherwise it's something specific. either way, we search
  ## for any matching window. if there's more than one,
  ## we bring up a window-picker
  else
    if [[ -z $(tmux list-windows -t "$TMUX_MASTER"|grep "$cmd") ]]; then
      tmux -2 new -t $TMUX_MASTER\; new-window "$input"
    else
      echo "looking for $cmd"
      tmux -2 new -t $TMUX_MASTER\; find-window -N "$cmd"
    fi
  fi
fi
