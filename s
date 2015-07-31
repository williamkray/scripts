#!/bin/bash

#if [[ $1 == rightscale@* ]]; then
#host=$1
#else
#host="rightscale@$1"
#fi
host=$1
tries=0
return="bad"

while [[ $tries -le 2 ]] && [[ $return != 'good' ]]; do
  if [[ $2 ]]; then
    if [[ $2 == "-t" ]]; then
      ssh $host -t '. /etc/profile; sudo su - root -c "/usr/bin/tail -f /var/log/messages "; sudo -i'
      if [[ $? != 0 ]]; then
        tries=$(($tries + 1))
      else
        return="good"
      fi
    fi
  else
    ssh $host -t '. /etc/profile; sudo -i'
    if [[ $? != 0 ]]; then
      tries=$(($tries + 1))
    else
      return="good"
    fi
  fi
done

