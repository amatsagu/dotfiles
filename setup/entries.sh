#!/bin/bash

cat << EOF
# ===========================================================================
# AMARI INSTALLATION - CLEARING DESKTOP ENTRIES
# ===========================================================================
EOF

sudo rm /usr/share/applications/yelp.desktop # "Getting help" manual from Gnome, not needed
sudo rm /usr/share/applications/vim.desktop # Vim text editor (we use nano or vsc) - keep in mind we only remove it from list on Mod+D list (fuzzel), not app itself
sudo rm /usr/share/applications/htop.desktop # Htop has no reason to have own entry, especially that it is reported to not even work as it is terminal app
sudo rm /usr/share/applications/footclient.desktop
sudo rm /usr/share/applications/foot-server.desktop
sudo rm /usr/share/applications/display-im6.q16.desktop

xdg-desktop-menu forceupdate