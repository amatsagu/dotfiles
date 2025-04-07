#!/bin/bash

install_sway_packages() {
    print_message info "Installing desktop portals, sway + essential apps & their extension packages..."

    sudo apt-get install \
        xdg-desktop-portal \
        xdg-desktop-portal-wlr \
        xdg-desktop-portal-gtk \
        sway \
        swaybg \
        swayidle \
        gtklock \
        gtklock-userinfo-module \
        waybar \
        pamixer \
        wlogout \
        mako \
        fuzzel \
        grim \
        slurp \
        mpv \
        imv \
        thunar \
        thunar-volman \
        thunar-archive-plugin \
        gvfs \
        gvfs-mtp \
        gvfs-nfs \
        gvfs-smb \
        foot \
        gnome-keyring \
        polkit \
        mate-polkit \
    -y >> /dev/null

    xdg-mime default foot.desktop x-scheme-handler/terminal >> /dev/null
    xdg-mime default foot.desktop x-scheme-handler/terminal-emulator >> /dev/null
    xdg-mime default Thunar.desktop inode/directory >> /dev/null
    xdg-mime default Thunar.desktop application/x-directory >> /dev/null
}