#!/bin/bash

# Install microcode & drivers to enable hardware acceleration (at least for integrated graphics, not tested on dedicated GPU)
proc_type=$(lscpu)
if grep -E "GenuineIntel" <<< ${proc_type}; then
    sudo apt install intel-microcode -y
elif grep -E "AuthenticAMD" <<< ${proc_type}; then
    sudo apt install amd64-microcode -y
    sudo apt install libegl-mesa0 libgbm1 libgl1-mesa-dri libglapi-mesa libglx-mesa0 mesa-utils-bin mesa-va-drivers mesa-vdpau-drivers mesa-vulkan-drivers -y
    # Note: This is technically not required, just adding here for sanity check :)
    # (tested on mobile ryzen CPU)
fi

# Install essential packages
sudo apt install htop zip curl wget network-manager rfkill gpg xdg-desktop-portal-wlr -y
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

# Install audio support
sudo apt install pipewire pipewire-audio-client-libraries pavucontrol pamixer -y
systemctl --user daemon-reload
systemctl --user --now enable pipewire pipewire-pulse

# Install gsettings (lib + command)
sudo apt install libglib2.0-0 libglib2.0-bin -y

# Install file manager, app launcher, and image capturer
sudo apt install nemo fuzzel grim slurp -y

# Install fonts
sudo apt install fonts-font-awesome fonts-roboto fonts-roboto-hinted fonts-roboto-unhinted fonts-roboto-fontface fonts-firacode fonts-hack fonts-hack-ttf fonts-hack-web fonts-noto fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-color-emoji fonts-noto-core fonts-noto-extra fonts-noto-hinted fonts-noto-mono fonts-noto-ui-core fonts-noto-ui-extra fonts-noto-unhinted -y

# Download & register custom set of cursors (for current user)
wget -cO- https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.local/share/icons
mkdir ~/.icons/default -p
cp ./setup/cursor-index.theme.desktop ~/.icons/default/index.theme

# Install icons & themes
sudo apt install papirus-icon-theme libgtk-3-0 -y