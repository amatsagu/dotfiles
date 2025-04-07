#!/bin/bash

print_message info "Installing latest version of Termius (stable)..."
sudo pacman -S --noconfirm termius >> /dev/null

print_message info "Modifying Termius entries to use wayland ozone layer (at ~/.local/share/applications)..."
sudo cp ./script/app/entries/termius.desktop /usr/share/applications/termius.desktop >> /dev/null
sudo cp ./script/app/entries/termius.desktop ~/.local/share/applications/termius.desktop >> /dev/null