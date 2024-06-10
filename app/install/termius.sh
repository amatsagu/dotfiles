#!/bin/bash

cat << EOF
# ===========================================================================
# TERMIUS INSTALLATION
# ===========================================================================
EOF

wget -O ~/TermiusSetup.deb "https://www.termius.com/download/linux/Termius.deb"
sudo apt install ~/TermiusSetup.deb -y
rm ~/TermiusSetup.deb
sudo cp ./app/desktop/termius-app.desktop /usr/share/applications/termius-app.desktop

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# FINISHED INSTALLATION
# ===========================================================================
EOF
