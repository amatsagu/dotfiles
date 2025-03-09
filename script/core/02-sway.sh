#!/bin/bash

install_sway_packages() {
    print_message info "Installing desktop portals, sway + essential apps & their extension packages..."

    # Utility, core packages
    sudo apt-get install \
        xdg-desktop-portal-wlr \
        xdg-desktop-portal-gtk \
        sway \
        swaybg \
        swayidle \
        swaylock \
        waybar \
        wlogout \
        mako-notifier \
        fuzzel \
        grim \
        slurp \
        mpv \
        imv \
        thunar \
        thunar-data \
	    thunar-volman \
	    thunar-archive-plugin \
	    gvfs \
	    gvfs-libs \
	    gvfs-fuse \
	    gvfs-daemons \
	    gvfs-common \
	    gvfs-backends \
	    nwg-look \
        mate-polkit \
    -y >> /dev/null

    xdg-mime default foot.desktop x-scheme-handler/terminal >> /dev/null
    xdg-mime default foot.desktop x-scheme-handler/terminal-emulator >> /dev/null
    xdg-mime default Thunar.desktop inode/directory >> /dev/null
    xdg-mime default Thunar.desktop application/x-directory >> /dev/null
}