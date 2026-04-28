#!/usr/bin/env bash

install_dotfiles() {
    papirus-folders -u -C yellow --theme Papirus-Dark >> /dev/null

    mkdir ~/.local/share/backgrounds -p >> /dev/null
    cp -r ./wallpapers/. ~/.local/share/backgrounds/ >> /dev/null

    cp -r ./configs/. ~/.config/ >> /dev/null

    # Ensure a default wallpaper is selected if none exists
    local CURRENT_WALLPAPER_FILE="$HOME/.local/share/backgrounds/.current-wallpaper"
    if [ ! -f "$CURRENT_WALLPAPER_FILE" ]; then
        ls -1 ./wallpapers/. | grep -E "\.(jpg|jpeg|png)$" | head -n 1 > "$CURRENT_WALLPAPER_FILE"
    fi

    # Generate initial colors
    if command -v matugen &>/dev/null; then
        local WP=$(cat "$CURRENT_WALLPAPER_FILE")
        matugen image "$HOME/.local/share/backgrounds/$WP"
    fi
}

apply_qt_settings() {
    # Configure Kvantum
    mkdir -p ~/.config/Kvantum
    echo "[General]
theme=Fluent-GreyDark" > ~/.config/Kvantum/kvantum.kvconfig

    # Configure QT5CT
    mkdir -p ~/.config/qt5ct
    echo "[Appearance]
icon_theme=Papirus-Dark
style=kvantum" > ~/.config/qt5ct/qt5ct.conf

    # Configure QT6CT (it can usually share or mirror qt5ct settings)
    mkdir -p ~/.config/qt6ct
    echo "[Appearance]
icon_theme=Papirus-Dark
style=kvantum" > ~/.config/qt6ct/qt6ct.conf
}

apply_gsettings() {
    # Theme & Color Scheme
    gsettings set org.x.apps.portal color-scheme "prefer-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
    gsettings set org.gnome.desktop.interface cursor-theme "phinger-cursors-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Fluent-grey-Dark"

    # Localization
    gsettings set org.gnome.desktop.interface clock-format "24h"
    gsettings set org.gtk.Settings.FileChooser clock-format "24h"

    # Fonts
    gsettings set org.gnome.desktop.interface font-name "Noto Sans 10"
    gsettings set org.gnome.desktop.interface document-font-name "Noto Sans 10"
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "Noto Sans Bold 10"
    gsettings set org.gnome.desktop.interface monospace-font-name "Fira Code 11"
}