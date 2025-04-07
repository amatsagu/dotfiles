#!/bin/bash

print_message info "Uninstalling Visual Studio Code..."
paru -Rs --noconfirm visual-studio-code-bin >> /dev/null
sudo rm /usr/share/applications/code.desktop >> /dev/null
sudo rm ~/.local/share/applications/code.desktop >> /dev/null
sudo rm /usr/share/applications/code-url-handler.desktop >> /dev/null
sudo rm ~/.local/share/applications/code-url-handler.desktop >> /dev/null
sudo rm /etc/apt/sources.list.d/vscode.list >> /dev/null
sudo rm /etc/apt/trusted.gpg.d/microsoft.gpg >> /dev/null