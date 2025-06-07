#!/usr/bin/env bash

# Utility, core packages
install_base_packages() {
    sudo pacman -S --noconfirm \
        network-manager-applet \
        nano \
        nano-syntax-highlighting \
        cachyos-packageinstaller \
        qt6-wayland \
        7zip \
        zip \
        unzip \
        git \
        wget \
        curl \
        htop \
        fastfetch \
        dconf \
        paru
}

install_sway_packages() {
    sudo pacman -S --noconfirm \
        xdg-desktop-portal \
        xdg-desktop-portal-wlr \
        xdg-desktop-portal-gtk \
        sway \
        swaybg \
        swayidle \
        gtklock \
        gtklock-userinfo-module \
        waybar \
        pamixer \
        wlogout \
        mako \
        fuzzel \
        grim \
        slurp \
        mpv \
        imv \
        thunar \
        thunar-volman \
        thunar-archive-plugin \
        tumbler \
        engrampa \
        gvfs \
        gvfs-mtp \
        gvfs-nfs \
        gvfs-smb \
        foot \
        gnome-keyring \
        polkit \
        mate-polkit

    xdg-mime default foot.desktop x-scheme-handler/terminal
    xdg-mime default foot.desktop x-scheme-handler/terminal-emulator
    xdg-mime default Thunar.desktop inode/directory
    xdg-mime default Thunar.desktop application/x-directory
}

install_theme_packages() {
    paru -S --noconfirm \
        phinger-cursors \
        papirus-icon-theme \
        fluent-gtk-theme \
        ttf-roboto \
        noto-fonts \
        noto-fonts-cjk \
        noto-fonts-emoji \
        noto-fonts-extra \
        cantarell-fonts \
        awesome-terminal-fonts \
        ttf-fira-code \
        ttf-firacode-nerd \
        ttf-nerd-fonts-symbols \
        ttf-opensans \
        papirus-folders
}

purge_base_noise_packages() {
    sudo pacman -Rs --noconfirm \
        power-profiles-daemon \
        cpupower \
        micro \
        vim \
        cachyos-zsh-config \
        cachyos-fish-config \
        cachyos-micro-settings \
        meld \
        alacritty \
        btop
    
    sudo pacman -R --noconfirm \
        octopi
}

install_laptop_packages() {
    sudo pacman -S --noconfirm \
        brightnessctl \
        blueman \
        tlp \
        tlp-rdw \
        acpi
}
