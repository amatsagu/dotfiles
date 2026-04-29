#!/usr/bin/env bash

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
