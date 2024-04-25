#!/bin/bash

LOG_FILE="./installation-history.log"

# Disable currently enabled display manager if exists (someone could add it from archinstall...)
if systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm'; then
  echo "[INFO] Disabling currently enabled display manager (if exists)"
  sudo systemctl disable --now $(systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm' | awk -F ' ' '{print $1}')
fi

# Update system packages
sudo apt update && sudo apt upgrade -y

# Make scripts executable
chmod +X "./setup/packages.sh"
chmod +X "./setup/gsettings.sh"

# Execute scripts
bash "./setup/packages.sh"
bash "./setup/gsettings.sh"

# Clone configs
mkdir ~/.config
cp -r ./config/* ~/.config

echo "[Info] Finished!"