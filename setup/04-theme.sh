#!/bin/bash

apply_theme() {
    # Download & register custom set of cursors (for current user cuz setting it globally was bugged?)
    print_message info "Installing Phinger cursors..."
    mkdir ~/.local/share/icons -p
    curl -sL https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.local/share/icons >> /dev/null
    mkdir ~/.icons/default -p
    cp ./setup/cursor-index.theme ~/.icons/default/index.theme

    # Download GTK theme (global)
    print_message info "Installing Fluent GTK theme..."
    mkdir ./setup/_gtk -p
    curl -sL https://github.com/vinceliuice/Fluent-gtk-theme/archive/refs/tags/2024-06-12.tar.gz | tar -xzf - -C ./setup/_gtk >> /dev/null
    cd ./setup/_gtk/Fluent-gtk-theme-2024-06-12
    ./install.sh -t default -c dark -s standard -i debian -l --tweaks noborder >> /dev/null
    cd - >> /dev/null
    rm ./setup/_gtk -r >> /dev/null

    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    gsettings set org.x.apps.portal color-scheme "prefer-dark"

    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
    gsettings set org.gnome.desktop.interface cursor-theme "phinger-cursors-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Fluent-Dark"

    gsettings set org.gnome.desktop.interface clock-format "24h"
    gsettings set org.gtk.Settings.FileChooser clock-format "24h"

    # Download icon theme (global)
    print_message info "Installing & modding Papirus icons..."
    sudo apt-get install papirus-icon-theme -y >> /dev/null
    curl -sL https://git.io/papirus-folders-install | sh >> /dev/null
    papirus-folders -u -C blue --theme Papirus-Dark >> /dev/null

    print_message ok "Successfully modified theme & icons."
}

apply_fonts() {
    print_message info "Installing fonts..."
    sudo apt-get install fonts-cantarell fonts-font-awesome fonts-roboto fonts-roboto-hinted fonts-roboto-unhinted fonts-roboto-fontface fonts-firacode fonts-noto fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-color-emoji fonts-noto-core fonts-noto-extra fonts-noto-hinted fonts-noto-mono fonts-noto-ui-core fonts-noto-ui-extra fonts-noto-unhinted -y >> /dev/null

    gsettings set org.gnome.desktop.interface font-name "Roboto 10"
    gsettings set org.gnome.desktop.interface document-font-name "Roboto 10"
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "Sans Bold 10"
    gsettings set org.gnome.desktop.interface monospace-font-name "Fira Code 11"

    # gsettings set org.gnome.desktop.interface font-antialiasing "rgba"
    # gsettings set org.gnome.desktop.interface font-hinting "slight"
    # gsettings set org.gnome.desktop.interface font-rgba-order "rgb"

    print_message ok "Successfully modified default fonts."
}
