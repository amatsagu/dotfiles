#!/bin/bash

SCREENSHOT_IMAGE=/tmp/screen.jpg
LOCK_IMAGE=~/.config/swaylock/lockscreen.jpg

grim $SCREENSHOT_IMAGE
ffmpeg -i $SCREENSHOT_IMAGE -vf "gblur=sigma=10, vignette=PI/5" -c:a copy $LOCK_IMAGE

swaylock -f --daemonize