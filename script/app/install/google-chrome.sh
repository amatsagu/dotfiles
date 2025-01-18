#!/bin/bash

print_message info "Installing latest version of Google Chrome (stable)..."
wget --quiet -O ~/GoogleChromeSetup.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" >> /dev/null
sudo apt-get install ~/GoogleChromeSetup.deb -y >> /dev/null
rm ~/GoogleChromeSetup.deb >> /dev/null

print_message info "Modifying Google Chrome entries to use wayland ozone layer (at ~/.local/share/applications)..."
sudo cp ./script/app/entries/google-chrome.desktop /usr/share/applications/google-chrome.desktop >> /dev/null
sudo cp ./script/app/entries/google-chrome.desktop ~/.local/share/applications/google-chrome.desktop >> /dev/null
xdg-settings set default-web-browser google-chrome.desktop >> /dev/null