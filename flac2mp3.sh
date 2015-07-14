#!/bin/bash

# Directory where music files are located. Must not include a trailing slash!
basepath=/home/william/test

cd "$basepath"

for dir in */* ; do
	cd "$basepath/$dir"
	if [[ -n $(ls *.flac) ]]; then
		mkdir .orig_flac
		for song in *.flac; do
			ffmpeg -i "$song" -qscale:a 0 "${song/%flac/mp3}"
		done
		mv *.flac .orig_flac/
	fi
done

