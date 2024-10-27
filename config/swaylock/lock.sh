#!/bin/bash

LOCK_IMAGE=~/.config/swaylock/lockscreen.jpg

grim $LOCK_IMAGE
convert $LOCK_IMAGE -blur 0x3 -fill black -colorize 25% $LOCK_IMAGE
