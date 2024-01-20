#!/bin/bash

# https://github.com/Amatsagu/Amari

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting..."
    exit 1
fi

clear

purple=$(tput setaf 5)
cyan=$(tput setaf 6)
gold=$(tput setaf 3)
green=$(tput setaf 2)
red=$(tput setaf 1)
color_reset=$(tput sgr0)

echo "$(cyan)01010011 01100001 01101001 01101000 01100001 01110100 01100101 $(color_reset)"
echo
echo

echo "Welcome to Amatsagu's OpenSUSE [Tumbleweed] - themed Hyprland install script!"
echo
echo "$(gold)ATTENTION:$(color_reset) Run a full system update and reboot first! (Highly Recommended)"
echo
echo "$(purple)NOTE:$(color_reset) You will be required to answer some questions during the installation!"
echo
echo "$(purple)NOTE:$(color_reset) If you are installing on a VM, ensure to enable 3D acceleration else Hyprland wont start!"
echo
echo "$(purple)NOTE:$(color_reset) Script will notify about all operations & save them in ./installation.log log file."
echo

read -p "$(cyan)Would you like to proceed? (y/n): $(color_reset)" proceed

if [ "$proceed" != "y" ]; then
    echo "Installation aborted."
    exit 1
fi