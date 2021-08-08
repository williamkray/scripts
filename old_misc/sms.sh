#!/usr/bin/env bash

device=$(kdeconnect-cli -a --id-only)

echo $device

if [ -z "$device" ]; then
  echo "no device available, exiting"
  exit 1
fi

recipient=$1

if ! [ $1 ]; then
  echo "no recipient supplied, exiting"
  exit 1
fi

echo "enter message content: "
read message

if [ -z "$message" ]; then
  echo "message is empty, exiting"
  exit 1
fi

kdeconnect-cli --send-sms "$message" --destination "$recipient" --device "$device"
