#!/bin/bash

# Set variables for paths
DESKTOP_DIR="/usr/share/applications"
TEMP_DIR=$(mktemp -d /tmp/desktop_backup.XXXXXX)
SEARCH_STRING="--ozone-platform=wayland"

# Function to scan and copy .desktop files
scan_and_copy() {
    echo "Scanning for desktop entries with the specific search string..."
    find "$DESKTOP_DIR" -name "*.desktop" -type f | while read -r DESKTOP_FILE; do
        if grep -q "$SEARCH_STRING" "$DESKTOP_FILE"; then
            cp "$DESKTOP_FILE" "$TEMP_DIR"
            echo "Copied $DESKTOP_FILE to $TEMP_DIR"
        fi
    done
}

# Function to restore .desktop files
restore_files() {
    echo "Restoring desktop entries..."
    find "$TEMP_DIR" -name "*.desktop" -type f | while read -r DESKTOP_FILE; do
        ORIGINAL_PATH="$DESKTOP_DIR/$(basename "$DESKTOP_FILE")"
        cp "$DESKTOP_FILE" "$ORIGINAL_PATH"
        echo "Restored $ORIGINAL_PATH"
    done
}

# Scan and copy desktop entries
scan_and_copy

# Run apt update and upgrade
echo "Running apt update and upgrade..."
if sudo apt update && sudo apt upgrade -y; then
    echo "Update and upgrade successful, restoring desktop entries..."
    restore_files
else
    echo "Update and upgrade failed. No files were restored."
fi

# Clean up temporary directory
rm -rf "$TEMP_DIR"
echo "Temporary files cleaned up."

exit 0
