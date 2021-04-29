#!/usr/bin/env bash

wf-recorder -g "$(slurp)" --file="~/Screen Recordings/screen_recording_$(date +%Y%m%d%S).mp4"
