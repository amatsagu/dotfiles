#!/bin/bash

print_message info "Registering Microsoft source list..."
curl -sS https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/microsoft.gpg >> /dev/null
sudo install -D -o root -g root -m 644 /etc/apt/trusted.gpg.d/microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg >> /dev/null
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >> /dev/null

print_message info "Installing latest version of Visual Studio Code (stable)..."
sudo apt-get update >> /dev/null
sudo apt-get install code -y >> /dev/null

print_message info "Modifying VSC entries to use wayland ozone layer (at ~/.local/share/applications)..."
sudo cp ./script/app/entries/code.desktop /usr/share/applications/code.desktop >> /dev/null
sudo cp ./script/app/entries/code-url-handler.desktop /usr/share/applications/code-url-handler.desktop >> /dev/null
sudo cp ./script/app/entries/code.desktop ~/.local/share/applications/code.desktop >> /dev/null
sudo cp ./script/app/entries/code-url-handler.desktop ~/.local/share/applications/code-url-handler.desktop >> /dev/null
xdg-mime default code.desktop text/plain >> /dev/null