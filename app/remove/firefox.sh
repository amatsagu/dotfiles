#!/bin/bash

cat << EOF
# ===========================================================================
# FIREFOX DELETION
# ===========================================================================
EOF

sudo rm -fr /usr/share/firefox
sudo rm /usr/bin/firefox
sudo rm /usr/share/applications/firefox.desktop
sudo rm ~/.cache/mozilla/ -R

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# FINISHED REMOVAL
# ===========================================================================
EOF