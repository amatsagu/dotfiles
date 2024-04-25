#!/bin/bash

# Directory where your images are stored
IMAGE_DIR="$HOME/.config/sway/backgrounds"

# Environment variable to store the index of the current background
BACKGROUND_INDEX_FILE="$HOME/.config/sway/backgrounds/.bg-cache"

# Ensure the index file exists and initialize it if not
if [ ! -f "$BACKGROUND_INDEX_FILE" ]; then
    echo "default.jpg" > "$BACKGROUND_INDEX_FILE"
fi

# Read the current index from the file
CURRENT_INDEX=$(cat "$BACKGROUND_INDEX_FILE")

# Get list of PNG and JPG files in the image directory
IMAGE_LIST=($(find "$IMAGE_DIR" -maxdepth 1 \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \)))

# Check if there are images to display
if [ ${#IMAGE_LIST[@]} -eq 0 ]; then
    notify-send -c sway -u critical "Background change failure" "There's no valid png/jpg images in $IMAGE_DIR."
    exit 1
fi

# Kill all running instances of swaybg
killall swaybg

# Cycle through images
CURRENT_IMAGE="${IMAGE_LIST[$CURRENT_INDEX]}"
swaybg -i "$CURRENT_IMAGE" -o "*" -m "fill" &

# Increment the index for the next time
NEW_INDEX=$(( ($CURRENT_INDEX + 1) % ${#IMAGE_LIST[@]} ))

# Update the index file
echo "$NEW_INDEX" > "$BACKGROUND_INDEX_FILE"

# Send info
# notify-send -c sway -u low -i "$CURRENT_IMAGE" "Background change" "Successfully set $BACKGROUND_INDEX_FILE as wallpaper."
