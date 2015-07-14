#!/bin/bash

current=`curl whatismyip.akamai.com`
record=`host mx.kray.ca | awk -F ' ' '{print $NF}'

if ![[ "$current" == "$record" ]]
then
    wget -O - http://freedns.afraid.org/dynamic/update.php?YU5pWmc4YVNLVXVTTGJiTkdJRXNZeTJYOjEwOTQ2NTU0 >> /tmp/freedns_mx_kray_ca.log 2>&1 &
fi