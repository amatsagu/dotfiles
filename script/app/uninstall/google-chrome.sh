#!/bin/bash

print_message info "Uninstalling Google Chrome..."
sudo apt-get purge google-chrome-stable -y >> /dev/null
sudo rm /usr/share/applications/google-chrome.desktop >> /dev/null
sudo rm ~/.local/share/applications/google-chrome.desktop >> /dev/null
sudo rm /home/amatsagu/.cache/google-chrome -r >> /dev/null