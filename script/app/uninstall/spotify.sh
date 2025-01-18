#!/bin/bash

print_message info "Uninstalling Spotify..."
sudo apt-get purge spotify-client -y >> /dev/null
sudo rm /usr/share/applications/spotify.desktop >> /dev/null
sudo rm ~/.local/share/applications/spotify.desktop >> /dev/null
sudo rm /etc/apt/sources.list.d/spotify.list >> /dev/null
sudo rm /etc/apt/trusted.gpg.d/spotify.gpg >> /dev/null

# Purge local app cache too
sudo rm ~/.cache/spotify -r >> /dev/null