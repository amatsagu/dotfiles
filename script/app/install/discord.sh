#!/bin/bash

print_message info "Installing latest version of Vesktop (optimized discord for wayland)..."
wget --quiet -O ~/VesktopSetup.deb "https://vencord.dev/download/vesktop/amd64/deb" >> /dev/null
sudo apt-get install ~/VesktopSetup.deb -y >> /dev/null
rm ~/VesktopSetup.deb >> /dev/null

print_message info "Modifying Vesktop entries to use wayland ozone layer (at ~/.local/share/applications)..."
sudo cp ./script/app/entries/vesktop.desktop /usr/share/applications/vesktop.desktop >> /dev/null
sudo cp ./script/app/entries/vesktop.desktop ~/.local/share/applications/vesktop.desktop >> /dev/null