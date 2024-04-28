#!/bin/bash

cat << EOF
# ===========================================================================
# GOOGLE CHROME DELETION
# ===========================================================================
EOF

sudo apt purge --auto-remove google-chrome-stable -y
sudo rm /usr/share/applications/google-chrome.desktop
sudo rm ~/.cache/google-chrome/ -R

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# FINISHED REMOVAL
# ===========================================================================
EOF