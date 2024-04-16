#!/bin/bash

# CONFIG VARIABLES
PREFER_WAYLAND=true # Whether it should modify below app desktop entries to force use wayland (most applications still search for xorg server by default).
INSTALL_FIREFOX=true
INSTALL_GOOGLE_CHROME=true
INSTALL_VISUAL_STUDIO_CODE=true # Warning: It uses official, proprietary version of Microsoft VSC. VSCodium and other alternatives struggle with poor ecosystem.
INSTALL_SPOTIFY=true
ALLOW_XWAYLAND=false
ALLOW_FLATPAK=false # Whether it should install flatpak + register flathub repository, even on arch - there are still some apps available only there.
UI_FRACTIONAL_SCALE=1.0 # It's for Sway's fractional scaling. By default 1.0 = 100% - it's recommended to use 1.1-1.5 for smaller laptop screens.
# ================

# Check if running as root. If root, script will exit
if [[ "$(id -u)" -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting..."
    exit 1
fi

# Update keyrings to latest to prevent packages failing to install
pacman -S archlinux-keyring --noconfirm
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

# Update system
sudo pacman -Syu --noconfirm

# Install git
if command -v git &>/dev/null; then
    echo "[INFO] Git v$(git -v | cut -d' ' -f3) is already installed in your system."
else
    echo "[INFO] Installing git..."
    sudo pacman -S git --noconfirm
fi

# Select aur helper - prefer yay
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

# Install essential packages
echo "[INFO] Installing QoL packages..."
$helper -Syu nano htop curl wget jq dmidecode neofetch --noconfirm --needed

# Try to add bluetooth support if supported
if rfkill list | grep -iq "Bluetooth"; then
    echo "[INFO] Installing bluetooth support..."
    $helper -Syu bluez bluez-utils blueman --noconfirm --needed
    systemctl --user enable --now bluetooth.service
fi

# Try to add brightnessctl for controlling backlight on supported (laptop) screens
if [ -d "/sys/class/backlight" ]; then
    echo "[INFO] Installing screen brightness support (laptop only)..."
    $helper -Syu brightnessctl --noconfirm --needed
fi

# Install audio server (pipewire)
echo "[INFO] Installing audio support (pipewire-pulse)..."
$helper -Syu pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse --noconfirm --needed
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
systemctl --user enable --now pipewire.service

# Install Sway & its core components
echo "[INFO] Installing Sway & core components..."
$helper -Syu sway foot swaybg swayidle swaylock waybar --noconfirm --needed

# Disable currently enabled display manager if exists (someone could add it from archinstall...)
if systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm'; then
  echo "[INFO] Disabling currently enabled display manager (if exists)"
  sudo systemctl disable --now $(systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm' | awk -F ' ' '{print $1}')
fi

# Install essential QoL packages so Sway can be fully functional out of the box
echo "[INFO] Installing essential packages..."
$helper -Syu polkit polkit-gnome gnome-keyring nautilus sushi grim slurp mako --noconfirm --needed

