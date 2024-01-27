#!/bin/bash

cat << EOF
# ===========================================================================
# STEP 1
# INSTALL CORE PACKAGES
# ===========================================================================
EOF

sudo apt update && sudo apt upgrade

# Install microcode && drivers to enable hardware acceleration (at least for integrated graphics)
proc_type=$(lscpu)
if grep -E "GenuineIntel" <<< ${proc_type}; then
    sudo apt install intel-microcode -y
    # No extra driver installation for intel APU as linux-firmware should already have it
elif grep -E "AuthenticAMD" <<< ${proc_type}; then
    sudo apt install amd64-microcode -y
    # AMD based computers should already add it but I found with Debian that sometimes browsers cannot enable hardware acceleration so let's add it for my own sanity
    sudo apt install libegl-mesa0 libgbm1 libgl1-mesa-dri libglapi-mesa libglx-mesa0 mesa-utils-bin mesa-va-drivers mesa-vdpau-drivers mesa-vulkan-drivers -y
fi

# Install essential packages
sudo apt install htop zip curl wget neofetch network-manager wayland-protocols gpg apt-transport-https sway waybar wlogout swaylock swayidle swaybg mako-notifier pipewire pipewire-audio-client-libraries pavucontrol volumeicon-alsa pamixer libglib2.0-0 libglib2.0-bin nemo fuzzel grim slurp imv -y
sudo apt remove zutty yelp yelp-* -y
sudo apt autoremove --purge -y

# Enable NetworkManager
systemctl enable --now NetworkManager

# Install all fonts & themes
sudo apt install materia-gtk-theme breeze-cursor-theme papirus-icon-theme fonts-font-awesome fonts-roboto fonts-roboto-hinted fonts-roboto-unhinted fonts-roboto-fontface fonts-firacode fonts-hack fonts-hack-ttf fonts-hack-web fonts-noto fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-color-emoji fonts-noto-core fonts-noto-extra fonts-noto-hinted fonts-noto-mono fonts-noto-ui-core fonts-noto-ui-extra fonts-noto-unhinted -y

# Copy all config & asset files into /home/$trk/.config
sudo cp ./config/* /home/$trk/.config/ -r -v
sudo chown $trk:$trk /home/$trk/.config/

# Force replace app entries (prepare for fuzzel)
sudo rm /usr/share/applications/*
sudo cp ./desktop/base/* /usr/share/applications/ -r -v

# Apply GTK themes & fonts
gsettings set org.gnome.nm-applet show-applet true
gsettings set org.gnome.desktop.interface gtk-theme "Materia-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface cursor-theme "breeze_cursors"
gsettings set org.nemo.desktop font "Roboto 10"
gsettings set org.gnome.desktop.interface font-name "Roboto 10"
gsettings set org.gnome.desktop.interface document-font-name "Roboto 10"
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Sans Bold 10"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Sans Bold 10"
gsettings set org.gnome.desktop.interface monospace-font-name "Fira Code 11"
gsettings set org.gnome.desktop.interface font-antialiasing "rgba"
gsettings set org.gnome.desktop.interface font-hinting "slight"
gsettings set org.gnome.desktop.interface font-rgba-order "rgb"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"

# [Optional] Add support for bluetooth
if [ "$res_bluetooth" == "y" ]; then
    sudo apt install rfkill bluetooth blueman bluez-firmware -y
fi

# [Optional] add brightness control for laptop screen
if [ "$using_laptop" == "y" ]; then
    sudo apt install brightnessctl -y
fi