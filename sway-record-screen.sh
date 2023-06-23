#!/usr/bin/env bash

wf-recorder -g "$(slurp)" --file="${HOME}/Videos/wayland_screen_recording_$(date +%Y%m%d%S).mp4"
