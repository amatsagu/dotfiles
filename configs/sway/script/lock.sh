#!/bin/bash

WALLPAPER_DIR="$HOME/.local/share/backgrounds"
SELECTED_WALLPAPER=$(cat "$WALLPAPER_DIR/.current-wallpaper")

gtklock -b "$WALLPAPER_DIR/$SELECTED_WALLPAPER" > /dev/null 2>&1 &