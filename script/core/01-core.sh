#!/bin/bash

install_base_packages() {
    print_message info "Installing essential packages..."

    # Utility, core packages
    sudo pacman -S --noconfirm \
        network-manager-applet \
        nano \
        nano-syntax-highlighting \
        cachyos-packageinstaller \
        qt6-wayland \
        7zip \
        zip \
        unzip \
        git \
        wget \
        curl \
        htop \
        fastfetch \
        dconf \
    >> /dev/null
}

purge_base_noise_packages() {
    print_message info "Removing not needed / duplicate packages..."

    sudo pacman -Rs --noconfirm \
        power-profiles-daemon \
        cpupower \
        micro \
        cmake \
        vim \
        cachyos-zsh-config \
        cachyos-fish-config \
    >> /dev/null
}