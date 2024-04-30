#!/bin/bash

cat << EOF
# ===========================================================================
# AMARI INSTALLATION - CLEARING DESKTOP ENTRIES
# ===========================================================================
EOF

sudo rm /usr/share/applications/yelp.desktop # "Getting help" manual from Gnome, not needed
sudo rm /usr/share/applications/vim.desktop # Vim text editor (we use nano or vsc) - keep in mind we only remove it from list on Mod+D list (fuzzel), not app itself
sudo rm /usr/share/applications/org.gnome/htop.desktop # Htop has no reason to have own entry, especially that it is reported to not even work as it is terminal app

# Hide those apps from app list (Mod+D, fuzzel) - they still can be accessed
sudo echo "NoDisplay=true" >> /usr/share/applications/org.gnome/FileRoller.desktop
sudo echo "NoDisplay=true" >> /usr/share/applications/org.gnome/footclient.desktop
sudo echo "NoDisplay=true" >> /usr/share/applications/org.gnome/foot.desktop
sudo echo "NoDisplay=true" >> /usr/share/applications/org.gnome/foot-server.desktop
sudo echo "NoDisplay=true" >> /usr/share/applications/org.gnome/display-im6.q16.desktop # ImageMagic color depth viewer