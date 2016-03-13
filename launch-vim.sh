#!/bin/bash
## this is just a wrapper, so that
## desktop calls to launch gvim or something like that
## will use my terminal emulator, create a session in tmux,
## and launch vim to edit whatever file was selected.
## I used to use it for a keyboard shortcut, but i 
## think auto-tmux.sh has grown to handle this concept.
## i still keep this around just for kicks though.

/usr/bin/urxvt -e /home/william/Scripts/auto-tmux.sh "vim $1"
