# scripts

a lot of these scripts are old, poorly written, or I don't even use anymore. some of them i use every day, and they are deeply intertwined with others to give me an awesome working environment in linux.

maybe you will get some use out of them.

the most important bits
=======================
the scripts I use most frequently are:
* autorandr.sh runs some commands depending on if my laptop is docked, what wifi networks are nearby, etc.
* auto-tmux.sh runs every time i open a terminal window, and launches everything within my existing tmux session
* ssh-dup.sh is used by my tmux config to duplicate a currently open ssh session in a new pane
* chrome-launcher.sh launches a chrome window using a specific profile, based on what virtual desktop i'm using in linux
* git-completion.bash and git-prompt.sh were pulled from somewhere else. it probably says somewhere in the script but i'm too lazy to check right now.
* vpn.sh and launchvpn.exp i use all the time to connect to my work's Cisco VPN
* power.sh (which just calls powerup and powerdown scripts from taylor chu [i think that's his name])
* s is used to open ssh links to servers in rightscale in conjunction with ssh.desktop (which is the file handler for ssh:// links)

anything else is just something i've either picked up along the way, or a quick one off that i've created to bind commands to keyboard shortcuts or something.
