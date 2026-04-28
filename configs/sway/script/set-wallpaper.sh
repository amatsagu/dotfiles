#!/bin/bash

WALLPAPER_DIR="$HOME/.local/share/backgrounds"
SELECTED_WALLPAPER=$(cat "$WALLPAPER_DIR/.current-wallpaper" 2>/dev/null)

if [ -z "$SELECTED_WALLPAPER" ] || [ ! -f "$WALLPAPER_DIR/$SELECTED_WALLPAPER" ]; then
    SELECTED_WALLPAPER=$(ls -1 "$WALLPAPER_DIR" | grep -E "\.(jpg|jpeg|png)$" | head -n 1)
fi

pkill swaybg 2> /dev/null
swaybg -i "$WALLPAPER_DIR/$SELECTED_WALLPAPER" -m fill > /dev/null 2>&1 &

disown 2> /dev/null