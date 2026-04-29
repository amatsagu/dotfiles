#!/usr/bin/env bash

install_dotfiles() {
    # Wallpapers & Configs
    mkdir -p ~/.local/share/backgrounds ~/.config/sway/config.d ~/.config/matugen/templates ~/.config/fuzzel ~/.config/sway/script &> /dev/null
    cp -r ./wallpapers/. ~/.local/share/backgrounds/ &> /dev/null
    cp -r ./configs/. ~/.config/ &> /dev/null
    chmod +x ~/.config/sway/script/*.sh 2>/dev/null

    # Customizations (Apply user-selected keyboard and scale)
    sed -i "s/xkb_layout .*/xkb_layout $KBD_LAYOUT/" ~/.config/sway/config.d/keybinds
    sed -i "s/set \$scale .*/set \$scale $SCREEN_SCALE/" ~/.config/sway/config.d/theme_and_screen

    # Global flags for Chromium/Electron
    for flagfile in ./configs/*-flags.conf; do
        [ -f "$flagfile" ] && sudo cp "$flagfile" "/etc/" 2>/dev/null
    done

    # Wallpaper selection
    local CURRENT_WALLPAPER_FILE="$HOME/.local/share/backgrounds/.current-wallpaper"
    if [ ! -f "$CURRENT_WALLPAPER_FILE" ]; then
        find ./wallpapers/ -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -printf "%f\n" | head -n 1 > "$CURRENT_WALLPAPER_FILE"
    fi
    
    # Matugen color generation (triggers update-icons.sh via matugen post-process)
    local WP=$(cat "$CURRENT_WALLPAPER_FILE")
    matugen image "$HOME/.local/share/backgrounds/$WP" --prefer darkness
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
