#!/bin/bash
## finds ssh sessions running in the current
## tmux pane, and creates a duplicate
## in a new pane. if the ssh session
## makes use of the s script, it skips trying
## to run that command and runs the s script anew.

pane_pid=$(tmux display-message -p "#{pane_pid}")
child_pids=$(pgrep -P $pane_pid)
cmds=$(ps -o cmd -p "$child_pids")
ssh_cmd=$(echo "$cmds"|egrep "ssh\s|s\s")

if [[ $(echo $ssh_cmd|grep "rightscale") ]]; then
  host=$(tmux display-message -p '#W')
  tmux split-window "/home/william/Scripts/s rightscale@$host"
else
  tmux split-window "$ssh_cmd"
fi
