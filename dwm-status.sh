#!/usr/bin/env bash

while true; do

  time_local=$(date +%I:%M%p)
  time_utc=$(date -u +%H:%M)

  xsetroot -name "${time_local} [${time_utc}]"
  sleep 2
done
