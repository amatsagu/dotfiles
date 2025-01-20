#!/bin/bash

print_message info "Registering Spotify source list..."
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg  >> /dev/null
sudo install -D -o root -g root -m 644 /etc/apt/trusted.gpg.d/spotify.gpg /etc/apt/keyrings/packages.spotify.gpg >> /dev/null
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list >> /dev/null

print_message info "Installing latest version of Spotify (stable)..."
sudo apt-get update >> /dev/null
sudo apt-get install spotify-client -y >> /dev/null

print_message info "Modifying Spotify entries to use wayland ozone layer (at ~/.local/share/applications)..."
sudo cp ./script/app/entries/spotify.desktop /usr/share/applications/spotify.desktop >> /dev/null
sudo cp ./script/app/entries/spotify.desktop ~/.local/share/applications/spotify.desktop >> /dev/null