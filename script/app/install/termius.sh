#!/bin/bash

print_message info "Installing latest version of Termius (stable)..."
wget --quiet -O ~/TermiusSetup.deb "https://www.termius.com/download/linux/Termius.deb" >> /dev/null
sudo apt-get install ~/TermiusSetup.deb -y >> /dev/null
rm ~/TermiusSetup.deb >> /dev/null

print_message info "Modifying Termius entries to use wayland ozone layer (at ~/.local/share/applications)..."
sudo cp ./script/app/entries/termius-app.desktop /usr/share/applications/termius-app.desktop >> /dev/null
sudo cp ./script/app/entries/termius-app.desktop ~/.local/share/applications/termius-app.desktop >> /dev/null