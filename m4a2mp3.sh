#!/bin/bash

# Directory where music files are located. Must not include a trailing slash!
basepath=/home/william/Music

cd "$basepath"

for dir in */* ; do
	cd "$basepath/$dir"
	if [[ -n $(ls *.m4a) ]]; then
		mkdir .orig_m4a
		for song in *.m4a; do
			ffmpeg -i "$song" "${song/%m4a/mp3}"
		done
		mv *.m4a .orig_m4a/
	fi
done

