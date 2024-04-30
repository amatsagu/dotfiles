#!/bin/bash

cat << EOF
# ===========================================================================
# VESKTOP (DISCORD) INSTALLATION
# ===========================================================================
EOF

wget -O ~/VesktopSetup.deb "https://vencord.dev/download/vesktop/amd64/deb"
sudo apt install ~/VesktopSetup.deb -y
rm ~/VesktopSetup.deb
sudo cp ./app/desktop/vesktop.desktop /usr/share/applications/discord.desktop

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# FINISHED INSTALLATION
# ===========================================================================
EOF
