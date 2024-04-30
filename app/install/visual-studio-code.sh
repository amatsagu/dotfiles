#!/bin/bash

cat << EOF
# ===========================================================================
# VISUAL STUDIO CODE INSTALLATION
# ===========================================================================
EOF

curl -sS https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/microsoft.gpg
echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt install apt-transport-https -y
sudo apt update
sudo apt install code -y
sudo cp ./app/desktop/code.desktop /usr/share/applications/code.desktop
xdg-mime default code.desktop text/plain

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# FINISHED INSTALLATION
# ===========================================================================
EOF
