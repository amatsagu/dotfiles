#!/bin/bash

LOG_FILE="./installation-history.log"

# Disable currently enabled display manager if exists (someone could add it from archinstall...)
if systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm'; then
  echo "[INFO] Disabling currently enabled display manager (if exists)"
  sudo systemctl disable --now $(systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm' | awk -F ' ' '{print $1}')
fi

# Function to execute a script quietly
execute_script_quietly() {
    local script="$1"
    local script_name="$(basename "$script")"

    echo "[INFO] Executing $script_name script..."

    # Execute the script and redirect stdout and stderr to a temporary file
    bash "$script" > >(tee -a "$LOG_FILE") 2> >(tee -a "$LOG_FILE" >&2)

    # Check the exit status of the script
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to execute $script_name script. Check $LOG_FILE for details."
    fi
}

# Update system packages
sudo apt update && sudo apt upgrade -y

# Make scripts executable
chmod +X "./setup/packages.sh"
chmod +X "./setup/gsettings.sh"

# Execute scripts
execute_script_quietly "./setup/packages.sh"
execute_script_quietly "./setup/gsettings.sh"

# Clone configs
mkdir ~/.config
cp -r ./config/* ~/.config