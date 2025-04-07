#!/bin/bash

print_message info "Uninstalling Termius..."
sudo pacman -Rs --noconfirm termius >> /dev/null
sudo rm /usr/share/applications/termius.desktop >> /dev/null
sudo rm ~/.local/share/applications/termius.desktop >> /dev/null