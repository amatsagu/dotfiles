#!/bin/bash

print_message info "Installing latest version of Visual Studio Code (stable)..."
paru -S --noconfirm visual-studio-code-bin >> /dev/null

print_message info "Modifying VSC entries to use wayland ozone layer (at ~/.local/share/applications)..."
sudo cp ./script/app/entries/code.desktop /usr/share/applications/code.desktop >> /dev/null
sudo cp ./script/app/entries/code-url-handler.desktop /usr/share/applications/code-url-handler.desktop >> /dev/null
sudo cp ./script/app/entries/code.desktop ~/.local/share/applications/code.desktop >> /dev/null
sudo cp ./script/app/entries/code-url-handler.desktop ~/.local/share/applications/code-url-handler.desktop >> /dev/null
xdg-mime default code.desktop text/plain >> /dev/null