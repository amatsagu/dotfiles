#!/bin/bash

# https://github.com/amatsagu/saihate

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting..."
    exit 1
fi

clear

source ./install-script/common.sh

user=$(whoami)

echo "$cyan 01000001 01101101 01100001 01110010 01101001$color_reset"
echo
echo

echo "Welcome to Amatsagu's Debian - themed Sway install script!"
echo
echo "$gold ATTENTION:$color_reset Run a full system update and reboot first! [highly recommended]"
echo
echo "$purple NOTE:$color_reset You will be required to answer some questions during the installation!"
echo
echo "$purple NOTE:$color_reset If you are installing on a VM, ensure to enable 3D acceleration or else Sway wont start!"
echo
echo "$purple NOTE:$color_reset Script will notify about all operations & save them in ./installation-log directory."
echo

read -p "$cyan Would you like to start installation for $user user? (y/n):$color_reset" proceed
echo

if [ "$proceed" != "y" ]; then
    echo "Installation aborted."
    exit 1
fi

if [ ! -d installation-log ]; then
    mkdir installation-log
fi

# Ensure that all in the scripts in directory are made executable.
chmod +x install-script/*

# Ask user what scripts to call
choice "Do you want to configure Bluetooth?" res_bluetooth
echo
multi_choice "Which web browser would you like to install?" "google-chrome, firefox, none," res_browser
echo
choice "Do you want to install XDG-DESKTOP-PORTAL? [required for working screen sharing on discord, obs, etc.]" res_xdg_portal
echo
choice "Do you want to install xwayland? [required to launch apps that are not yet supported on wayland]" res_xwayland
echo
choice "Do you want to automatically login current user into Sway session and activate swaylock on each start? [will modify ~/.profile]" res_autologin
echo
multi_choice "After what time of inactivity would you like to lock your session?" "1m, 3m, 5m, 10m, 15m, never," res_lock_timeout
echo

read -p "$cyan Finished basic questions. Just before magic happens, would you like to add extra applications? (y/n):$color_reset" extra
echo

if [ "$extra" == "y" ]; then
    choice "Do you want to install Spotify?" res_spotify
    echo
    multi_choice "Do you want to install Visual Studio Code/VSCodium? [will modify ~/.profile]" "vscode, vscodium, none," res_code
    echo
    choice "Do you want to install latest version of Go programming language? [will modify ~/.profile]" res_go
    echo
    choice "Do you want to install latest version of Rust programming language? [will fetch & run official installation script at the end]" res_rs
    echo
    multi_choice "Do you want to install latest version of Node/Deno/Bun? [will attempt to run official installation script if available]" "node, deno, bun, none," res_js
    echo
fi