#!/bin/bash

cat << EOF
# ===========================================================================
# STEP 3
# INCLUDE OPTIONAL WAYLAND PORTALS SUPPORT
# ===========================================================================
EOF

if [ "$res_xdg_portal" == "y" ]; then
    sudo apt install xdg-desktop-portal-wlr -y
fi

if [ "$res_xwayland" == "y" ]; then
    sudo apt install xwayland -y
fi