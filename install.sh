#!/bin/bash

# ================================================================
# CONFIG VARIABLES

PREFER_WAYLAND=true             # Whether it should modify below app desktop entries to force use wayland (most applications still search for xorg server by default).
INSTALL_FIREFOX=false
INSTALL_GOOGLE_CHROME=true      # Warning: Many people experience issues running latest versions of google chrome using xwayland - it's recommended to use "PREFER_WAYLAND" flag. 
INSTALL_VISUAL_STUDIO_CODE=true # Warning: It uses official, proprietary version of Microsoft VSC. VSCodium and other alternatives struggle with poor ecosystem.
INSTALL_SPOTIFY=true
INSTALL_DISCORD=true
INSTALL_GIMP=true
ALLOW_XWAYLAND=false            # Warning: It's almost required to allow xwayland if you decide to not use "PREFER_WAYLAND" flag at the top of this config.
ALLOW_FLATPAK=false             # Whether it should install flatpak + register flathub repository, even on arch - there are still some apps available only there.
UI_FRACTIONAL_SCALE=1.0         # It's for Sway's fractional scaling. By default 1.0 = 100% - it's recommended to use 1.1-1.5 for smaller laptop screens.
WINDOW_GAPS=5                   # Size of Sway's gaps between windows (in pixels).
CLOCK_FORMAT="24h"              # Whether you want to use 12h or 24h time format.
KEYBOARD_XKB_LAYOUT="pl"
FONT_HINTING="slight"           # Don't touch if you don't know what it does. If you use 27'' or even bigger screen, you may want to test "none" option if you experience blurry font.
RGBA_PIXEL_ORDER="rgb"          # Again, don't touch unless you know that your screen specifically needs other setting.

# ================================================================

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
sudo pacman -Syyu --noconfirm # Don't ask why, it somehow fixes sometimes missing fuzzel package

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
$helper -Syu sway foot xdg-desktop-portal-wlr xdg-desktop-portal-gtk swaybg swayidle swaylock waybar --noconfirm --needed

# Disable currently enabled display manager if exists (someone could add it from archinstall...)
if systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm'; then
  echo "[INFO] Disabling currently enabled display manager (if exists)"
  sudo systemctl disable --now $(systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm' | awk -F ' ' '{print $1}')
fi

# Install essential QoL packages so Sway can be fully functional out of the box
echo "[INFO] Installing essential packages..."
$helper -Syu glib2 polkit polkit-gnome gnome-keyring nemo grim slurp mako thunar --noconfirm --needed

# Instll fonts
echo "[INFO] Installing fonts..."
$helper -Syu ttf-font-awesome ttf-firacode-nerd ttf-hack-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --noconfirm --needed

# Install themes
echo "[INFO] Installing themes..."
$helper -Syu papirus-icon-theme phinger-cursors --noconfirm --needed

# Apply themes & fonts
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "phinger-cursors-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.cinnamon.desktop.interface icon-theme-backup "Papirus-Dark"
gsettings set org.cinnamon.desktop.interface cursor-theme "phinger-cursors-dark"
gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.cinnamon.desktop.interface gtk-theme-backup "Adwaita-dark"
gsettings set org.x.apps.portal color-scheme "prefer-dark"
gsettings set org.nemo.desktop font "Noto Sans 10"
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Noto Sans Bold 10"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Noto Sans Bold 10"
gsettings set org.gtk.Settings.ColorChooser custom-colors "[(0.81568627450980391, 0.81176470588235294, 0.80000000000000004, 1.0), (0.20000000000000001, 0.7803921568627451, 0.87058823529411766, 1.0), (0.16470588235294117, 0.63137254901960782, 0.70196078431372544, 1.0), (0.63921568627450975, 0.27843137254901962, 0.72941176470588232, 1.0), (0.16470588235294117, 0.4823529411764706, 0.87058823529411766, 1.0), (0.070588235294117646, 0.28235294117647058, 0.54509803921568623, 1.0), (0.9882352941176471, 0.9137254901960784, 0.30980392156862746, 1.0), (0.9137254901960784, 0.67843137254901964, 0.047058823529411764, 1.0)]"

gsettings set org.gnome.desktop.interface clock-format "$CLOCK_FORMAT"
gsettings set org.gtk.Settings.FileChooser clock-format "$CLOCK_FORMAT"
# Note: You may want to change time order to 12h if you're American.

gsettings set org.gnome.desktop.interface font-antialiasing "rgba"
gsettings set org.gnome.desktop.interface font-hinting "$FONT_HINTING"
gsettings set org.gnome.desktop.interface font-rgba-order "$RGBA_PIXEL_ORDER"
# Note: Depending on your screen specifications, you may want to change hinting or pixel order.

gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.interface font-name "Noto Sans 10"
gsettings set org.gnome.desktop.interface document-font-name "Noto Sans 10"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Noto Sans Bold 10"
gsettings set org.gnome.desktop.interface monospace-font-name "FiraCode Nerd Font 11"

# Clean orphaned & build only packages
sudo pacman -Qdtq | sudo pacman -Rns -