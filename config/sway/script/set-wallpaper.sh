#!/bin/bash

WALLPAPER_DIR="$HOME/.local/share/backgrounds"
SELECTED_WALLPAPER=$(cat "$WALLPAPER_DIR/.current-wallpaper")

pkill swaybg 2> /dev/null
swaybg -i "$WALLPAPER_DIR/$SELECTED_WALLPAPER" -m fill > /dev/null 2>&1 &

disown 2> /dev/null