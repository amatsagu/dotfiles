#!/bin/bash

SCREENSHOT_IMAGE="/tmp/screen.jpg"
LOCK_IMAGE="~/.config/swaylock/lockscreen.jpg"

grim $SCREENSHOT_IMAGE
rm -f "$SCREENSHOT_IMAGE"

ffmpeg -y -i $SCREENSHOT_IMAGE -vf "gblur=sigma=10, vignette=PI/5" $LOCK_IMAGE

swaylock -f --daemonize