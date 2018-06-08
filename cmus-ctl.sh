#!/bin/bash

case $1 in
  next)
    cmus-remote -n;;
  prev)
    cmus-remote -r;;
  toggle)
    cmus-remote -u
    cmus-info
    ;;
esac
