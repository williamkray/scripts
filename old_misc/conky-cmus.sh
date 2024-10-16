#!/bin/bash

STATUS=$( cmus-remote -Q 2>/dev/null | grep "status " | sed 's/^status //g')
FILE=$( cmus-remote -Q 2>/dev/null | grep "file" | sed 's/^file //g' )
ARTIST=$( cmus-remote -Q 2>/dev/null | grep " artist " | sed 's/tag\ artist/Artist\:/g' )
ALBUM=$( cmus-remote -Q 2>/dev/null | grep " album " | sed 's/tag\ album/Album\:/g' )
TITLE=$( cmus-remote -Q 2>/dev/null | grep " title " | sed 's/tag\ title/Song\:/g' )

info="$ARTIST
  $TITLE
  $ALBUM"

if ! [ "$STATUS" = "playing" ]; then
  echo -n "stopped"
  if [ -f /tmp/cover.jpg ]; then
    rm -f /tmp/cover.jpg
  fi
else
  echo -n "playing"
fi


