#!/bin/bash

cat << EOF
# ===========================================================================
# AMARI INSTALLATION SCRIPT
# ===========================================================================
EOF

# Disable currently enabled display manager if exists (someone could add it from archinstall...)
if systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm'; then
  echo "[INFO] Disabling currently enabled display manager!"
  sudo systemctl disable --now $(systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm' | awk -F ' ' '{print $1}')
fi

# Update system packages
sudo apt update && sudo apt upgrade -y

cat << EOF
# ===========================================================================
# AMARI INSTALLATION - START
# ===========================================================================
EOF

# Make scripts executable
chmod +x "./setup/packages.sh"
chmod +x "./setup/gsettings.sh"
chmod +x "./setup/entries.sh"

# Execute scripts
bash "./setup/packages.sh"
bash "./setup/gsettings.sh"
bash "./setup/entries.sh"

# Clone configs
cat << EOF
# ===========================================================================
# AMARI INSTALLATION - COPYING CONFIG FILES
# ===========================================================================
EOF

mkdir ~/.config
cp -r -v ./config/* ~/.config

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# AMARI INSTALLATION - FINISH
# ===========================================================================

- It is recommended to restart your computer. Use "sway" command to enter desktop.
  We assume you know basics of Sway, Waybar or Wayland in general. Each config is
  easy to edit - left with comments. For more help - check installation steps on
  project's github page. Good luck!
EOF