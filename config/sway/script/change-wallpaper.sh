#!/bin/bash

WALLPAPER_DIR="$HOME/.local/share/backgrounds"
CURRENT_WALLPAPER_FILE="$WALLPAPER_DIR/.current-wallpaper"

while read -r SELECTED_WALLPAPER; do
    if [ -z "$SELECTED_WALLPAPER" ]; then
        exit 0
    fi

    # Persist the selection for confirmation
    echo "$SELECTED_WALLPAPER" > "$CURRENT_WALLPAPER_FILE"
    pkill swaybg 2> /dev/null
    swaybg -i "$WALLPAPER_DIR/$SELECTED_WALLPAPER" -m fill > /dev/null 2>&1 &

done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" \) -printf "%f\n" | fuzzel --dmenu)

disown 2> /dev/null