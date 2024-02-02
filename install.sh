#!/bin/bash

# Check if running as root. If root, script will exit
if [[ "$(id -u)" -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting..."
    exit 1
fi

# Update keyrings to latest to prevent packages failing to install
pacman -S archlinux-keyring --noconfirm
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

# Update system
sudo pacman -Syu

# Install git
if command -v git &>/dev/null; then
    echo "[INFO] Git v$(git -v | cut -d' ' -f3) is already installed in your system."
else
    echo "[INFO] Installing git..."
    sudo pacman -S git --noconfirm
fi

# Install yay
helper="yay"
if command -v yay &>/dev/null; then
    echo "[INFO] Yay (AUR helper) $(yay -V | cut -d' ' -f2) is already installed in your system."
else
    if command -v paru &>/dev/null; then
        helper="paru"
        echo "[INFO] Paru $(paru -V | cut -d' ' -f2) is already installed in your system."
    else
        echo "[INFO] Installing yay..."
        pacman -Syu base-devel --noconfirm --needed
        cd ~ 
        git clone https://aur.archlinux.org/yay.git
        cd ./yay
        makepkg -si --noconfirm
        cd ..
        rm ./yay -r
    fi
fi

# Warn about pipewire
echo "[WARN] Skipping installation of pipewire! We trust you've read ./doc/security.md and added pipewire during archinstall."
echo "  In case you didn't - Type \"yay -S pipewire wireplumber\" and reset your machine."

# Install essential packages
echo "[INFO] Installing Hyprland + essential packages..."
$helper -Syu hyprland xdg-desktop-portal-hyprland alacritty --noconfirm --needed

# Disable currently enabled display manager if exists
if systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm'; then
  echo "[INFO] Disabling currently enabled display manager"
  sudo systemctl disable --now $(systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm' | awk -F ' ' '{print $1}')
fi