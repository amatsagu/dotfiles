#!/bin/bash

print_message info "Uninstalling Termius..."
sudo apt-get purge termius-app -y >> /dev/null
sudo rm /usr/share/applications/termius-app.desktop >> /dev/null
sudo rm ~/.local/share/applications/termius-app.desktop >> /dev/null