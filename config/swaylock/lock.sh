#!/bin/bash

LOCK_IMAGE=~/.config/swaylock/lockscreen.jpeg

grim $LOCK_IMAGE
convert $LOCK_IMAGE -blur 0x3 -fill black -colorize 25% $LOCK_IMAGE
swaylock \
    --image=$LOCK_IMAGE \
    --ignore-empty-password \
    --indicator-radius=150 \
    --line-color=#68a1be \
    --ring-color=#498bab \
    --separator-color=#498bab \
    --text-color=#e8eaed \
    --layout-text-color=#e8eaed \
    --inside-ver-color=#dda456 \
    --line-ver-color=#dda456 \
    --ring-ver-color=#d58e2a \
    --key-hl-color=#b7bdf8 \
    --line-wrong-color=#dd5656
