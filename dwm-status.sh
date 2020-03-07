#!/usr/bin/env bash

time_local=$(date +%I:%M%p)
time_utc=$(date -u +%H:%M)

while true; do
  xsetroot -name "${time_local} [${time_utc}]"
  sleep 2
done
