#!/bin/bash

apply_theme() {
    print_message info "Applying GTK theme & icons..."
    
    # Download & install script to update folder colors to red
    curl -sL https://git.io/papirus-folders-install | sh > /dev/null 2>&1

    # Download & register custom set of cursors (for current user)
    mkdir ~/.local/share/icons -p
    curl -sL https://github.com/phisch/phinger-cursors/releases/latest/download/phinger-cursors-variants.tar.bz2 | tar xfj - -C ~/.local/share/icons >> /dev/null
    mkdir ~/.icons/default -p
    cp ./setup/cursor-index.theme ~/.icons/default/index.theme

    # Download theme
    mkdir ./setup/_gtk -p
    curl -sL https://github.com/vinceliuice/Fluent-gtk-theme/archive/refs/tags/2024-06-12.tar.gz | tar -xzf - -C ./setup/_gtk >> /dev/null
    cd ./setup/_gtk


    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    gsettings set org.x.apps.portal color-scheme "prefer-dark"

    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
    gsettings set org.gnome.desktop.interface cursor-theme "phinger-cursors-dark"
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita

    # gsettings set org.cinnamon.desktop.interface icon-theme "Papirus-Dark"
    # gsettings set org.cinnamon.desktop.interface icon-theme-backup "Papirus-Dark"
    # gsettings set org.cinnamon.desktop.interface cursor-theme "phinger-cursors-dark"
    # gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita"
    # gsettings set org.cinnamon.desktop.interface gtk-theme-backup "Adwaita"

    gsettings set org.gnome.desktop.interface clock-format "24h"
    gsettings set org.gtk.Settings.FileChooser clock-format "24h"

    papirus-folders -u -C blue --theme Papirus-Dark >> /dev/null

    print_message ok "Successfully modified theme & icons."
}

apply_fonts() {
    print_message info "Applying fonts..."

    # gsettings set org.nemo.desktop font "Roboto 10"
    gsettings set org.gnome.desktop.interface font-name "Roboto 10"
    gsettings set org.gnome.desktop.interface document-font-name "Roboto 10"
    # gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Sans Bold 10"
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "Sans Bold 10"
    gsettings set org.gnome.desktop.interface monospace-font-name "Fira Code 11"

    # gsettings set org.gnome.desktop.interface font-antialiasing "rgba"
    # gsettings set org.gnome.desktop.interface font-hinting "slight"
    # gsettings set org.gnome.desktop.interface font-rgba-order "rgb"

    print_message ok "Successfully modified default fonts."
}