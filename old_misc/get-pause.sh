#!/usr/bin/env bash

if [[ -f ~/.pause ]]; then
  cat ~/.pause
else
  printf ""
fi
