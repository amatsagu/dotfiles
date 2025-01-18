#!/bin/bash

print_message info "Uninstalling Vesktop (optimized discord for wayland)..."
sudo apt-get purge vesktop -y >> /dev/null
sudo rm /usr/share/applications/vesktop.desktop >> /dev/null
sudo rm ~/.local/share/applications/vesktop.desktop >> /dev/null
sudo rm /home/amatsagu/.config/vesktop -r >> /dev/null