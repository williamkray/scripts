#!/usr/bin/env bash                                                            

for i in "$1/*.mp3"; do 
  ffmpeg -i "$i" -b:a 256k -v 0 -f mp3 "/run/media/william/DASH PRO/My Music/Playlist 1/$1/$i" 
done
