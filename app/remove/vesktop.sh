#!/bin/bash

cat << EOF
# ===========================================================================
# VESKTOP DELETION
# ===========================================================================
EOF

sudo apt purge --auto-remove vesktop -y
sudo rm /usr/share/applications/vesktop.desktop

printf "\n\n\n\n\n\n\n\n\n\n"

cat << EOF
# ===========================================================================
# FINISHED REMOVAL
# ===========================================================================
EOF