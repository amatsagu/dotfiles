#!/usr/bin/env bash

install_dotfiles() {
    papirus-folders -u -C yellow --theme Papirus-Dark >> /dev/null

    mkdir ~/.local/share/backgrounds -p >> /dev/null
    cp ./wallpapers/* ~/.local/share/backgrounds -r >> /dev/null

    cp ./configs/* ~/.config -r >> /dev/null
}

apply_gsettings() {
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    # gsettings set org.x.apps.portal color-scheme "prefer-dark"

    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
    gsettings set org.gnome.desktop.interface cursor-theme "phinger-cursors-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Fluent-grey-Dark"

    gsettings set org.gnome.desktop.interface clock-format "24h"
    gsettings set org.gtk.Settings.FileChooser clock-format "24h"

    gsettings set org.gnome.desktop.interface font-name "Roboto 10"
    gsettings set org.gnome.desktop.interface document-font-name "Roboto 10"
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "Sans Bold 10"
    gsettings set org.gnome.desktop.interface monospace-font-name "Fira Code 11"
}