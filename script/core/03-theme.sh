#!/bin/bash

install_cursors() {
    print_message info "Installing Phinger cursors for $USER user... (can take a while)"

    mkdir ~/.local/share/icons -p
    curl -sL https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.local/share/icons
    mkdir ~/.icons/default -p
    cp ./script/cursor-index.theme ~/.icons/default/index.theme
}

install_icons() {
    print_message info "Installing & modding Papirus icons... (can take a while)"

    sudo apt-get install papirus-icon-theme -y >> /dev/null
    curl -sL https://git.io/papirus-folders-install | sh >> /dev/null
    papirus-folders -u -C yaru --theme Papirus-Dark >> /dev/null
}

install_gtk_theme() {
    print_message info "Installing Fluent GTK theme (12.06.2024 release)... (can take a while)"
    mkdir ./script/_gtk -p >> /dev/null
    curl -sL https://github.com/vinceliuice/Fluent-gtk-theme/archive/refs/tags/2024-06-12.tar.gz | tar -xzf - -C ./script/_gtk >> /dev/null
    cd ./script/_gtk/Fluent-gtk-theme-2024-06-12
    ./install.sh -t red -c dark -s standard -i debian -l --tweaks noborder >> /dev/null
    cd - >> /dev/null
    rm ./script/_gtk -r >> /dev/null
}

install_font_packages() {
    print_message info "Installing fonts..."

    sudo apt-get install \
        fonts-cantarell \
        fonts-font-awesome \
        fonts-roboto \
        fonts-roboto-hinted \
        fonts-roboto-unhinted \
        fonts-roboto-fontface \
        fonts-firacode \
        fonts-noto \
        fonts-noto-cjk \
        fonts-noto-cjk-extra \
        fonts-noto-color-emoji \
        fonts-noto-core \
        fonts-noto-extra \
        fonts-noto-hinted \
        fonts-noto-mono \
        fonts-noto-ui-core \
        fonts-noto-ui-extra \
        fonts-noto-unhinted \
    -y >> /dev/null
}

install_wallpapers() {
    print_message info "Copying wallpapers (at ~/.local/share/backgrounds)..."

    mkdir ~/.local/share/backgrounds -p >> /dev/null
    cp ./wallpaper/* ~/.local/share/backgrounds -r >> /dev/null
}