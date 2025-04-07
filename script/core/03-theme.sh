#!/bin/bash

install_theme_packages() {
    print_message info "Installing fonts + theme packages..."

    # Utility, core packages
    sudo pacman -S --noconfirm \
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
        ttf-opensans \
    >> /dev/null

    paru -S --noconfirm papirus-folders >> /dev/null
    papirus-folders -u -C blue --theme Papirus-Dark >> /dev/null
}

install_wallpapers() {
    print_message info "Copying wallpapers (at ~/.local/share/backgrounds)..."

    mkdir ~/.local/share/backgrounds -p >> /dev/null
    cp ./wallpaper/* ~/.local/share/backgrounds -r >> /dev/null
}