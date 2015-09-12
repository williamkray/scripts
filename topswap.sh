#!/bin/bash
## simple one-liner to find the top 20 programs using swap on a linux box.
## mostly so i don't have to remember this command.
## taken from http://www.cyberciti.biz/faq/linux-which-process-is-using-swap/

for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | head -20
