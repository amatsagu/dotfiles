#!/bin/bash

cat << EOF
# ===========================================================================
# AMATSAGU's CUSTOM SWAY INSTALLATION - GET ALL CORE PACKAGES
# ===========================================================================
EOF

# Install microcode & drivers to enable hardware acceleration (at least for integrated graphics, not tested on dedicated GPU)
proc_type=$(lscpu)
if grep -E "GenuineIntel" <<< ${proc_type}; then
    sudo apt install intel-microcode -y
elif grep -E "AuthenticAMD" <<< ${proc_type}; then
    sudo apt install amd64-microcode -y
fi

# Install essential packages
sudo apt install htop zip curl wget network-manager network-manager-gnome rfkill neofetch gpg xdg-desktop-portal-wlr -y
sudo apt autoremove --purge -y
systemctl enable --now NetworkManager

# Install backlight control (works only for laptops or some mobile screens)
sudo apt install brightnessctl -y

# Try to add bluetooth support
if sudo rfkill list | grep -iq "Bluetooth"; then
    sudo apt install blueman -y
fi

# Install Sway + its core components like background image or screen lock functionality
sudo apt install sway waybar wlogout swaylock swayidle swaybg mako-notifier -y

systemctl --user --now enable pipewire pipewire-pulse

# Install common libs
sudo apt install libglib2.0-0 libglib2.0-bin libnotify-bin -y

# Install file manager, app launcher, and image capturer
sudo apt install fuzzel grim slurp -y

# Install fonts
sudo apt install fonts-cantarell fonts-font-awesome fonts-roboto fonts-roboto-hinted fonts-roboto-unhinted fonts-roboto-fontface fonts-firacode fonts-noto fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-color-emoji fonts-noto-core fonts-noto-extra fonts-noto-hinted fonts-noto-mono fonts-noto-ui-core fonts-noto-ui-extra fonts-noto-unhinted -y

# Download & register custom set of cursors (for current user)
mkdir ~/.local/share/icons -p
wget -cO- https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.local/share/icons
mkdir ~/.icons/default -p
cp ./setup/cursor-index.theme ~/.icons/default/index.theme

# Install icons & themes
sudo apt install papirus-icon-theme libgtk-3-0 -y

# Install audio support
sudo apt install pipewire pipewire-audio-client-libraries pavucontrol pamixer -y

cat << EOF
# ===========================================================================
# AMATSAGU's CUSTOM SWAY INSTALLATION - CONFIGURING AUDIO SERVER
# ===========================================================================
EOF

systemctl --user daemon-reload
