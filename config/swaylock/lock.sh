#!/bin/bash

LOCK_IMAGE=~/.config/swaylock/lockscreen.jpeg

grim $LOCK_IMAGE
convert $LOCK_IMAGE -blur 0x3 -fill black -colorize 25% $LOCK_IMAGE
