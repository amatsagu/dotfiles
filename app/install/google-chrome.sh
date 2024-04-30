#!/bin/bash

cat << EOF
# ===========================================================================
# GOOGLE CHROME INSTALLATION
# ===========================================================================
EOF

wget -O ~/GoogleChromeSetup.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo apt install ~/GoogleChromeSetup.deb -y
rm ~/GoogleChromeSetup.deb
sudo cp ./app/desktop/google-chrome.desktop /usr/share/applications/google-chrome.desktop
xdg-settings set default-web-browser google-chrome.desktop

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# FINISHED INSTALLATION
# ===========================================================================
EOF
