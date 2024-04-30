#!/bin/bash

cat << EOF
# ===========================================================================
# SPOTIFY INSTALLATION
# ===========================================================================
EOF

curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt install apt-transport-https -y
sudo apt-get update
sudo apt-get install spotify-client -y
sudo cp ./app/desktop/spotify.desktop /usr/share/applications/spotify.desktop

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# FINISHED INSTALLATION
# ===========================================================================
EOF
