#!/usr/bin/env bash

# Utility, core packages
install_base_packages() {
    sudo pacman -S --noconfirm \
        network-manager-applet \
        nano \
        nano-syntax-highlighting \
        cachyos-packageinstaller \
        qt5-wayland \
        qt6-wayland \
        qt5ct \
        qt6ct \
        xwayland \
        7zip \
        zip \
        unzip \
        git \
        wget \
        curl \
        htop \
        fastfetch \
        dconf \
        libdisplay-info \
        jq
}

install_sway_packages() {
    sudo pacman -S --noconfirm \
        xdg-desktop-portal \
        xdg-desktop-portal-wlr \
        xdg-desktop-portal-gtk \
        xdg-desktop-portal-xapp \
        sway \
        swaybg \
        swayidle \
        swayosd \
        gtklock \
        gtklock-userinfo-module \
        waybar \
        pamixer \
        wlogout \
        mako \
        fuzzel \
        grim \
        slurp \
        wl-clipboard \
        clipman \
        mpv \
        thunar \
        thunar-volman \
        thunar-archive-plugin \
        tumbler \
        engrampa \
        gvfs \
        gvfs-mtp \
        gvfs-nfs \
        gvfs-smb \
        foot \
        gnome-keyring \
        polkit \
        mate-polkit

    xdg-mime default foot.desktop x-scheme-handler/terminal
    xdg-mime default foot.desktop x-scheme-handler/terminal-emulator
    xdg-mime default Thunar.desktop inode/directory
    xdg-mime default Thunar.desktop application/x-directory
}

install_theme_packages() {
    local AUR_HELPER=""
    if command -v paru &>/dev/null; then
        AUR_HELPER="paru"
    elif command -v yay &>/dev/null; then
        AUR_HELPER="yay"
    else
        info "AUR helper not found. Attempting to install paru..."
        sudo pacman -S --needed base-devel git
        local tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/paru-bin.git "$tmpdir"
        (cd "$tmpdir" && makepkg -si --noconfirm)
        rm -rf "$tmpdir"
        AUR_HELPER="paru"
    fi

    $AUR_HELPER -S --noconfirm \
        matugen-bin \
        kvantum-qt5 \
        fluent-kvantum-theme-git \
        phinger-cursors \
        papirus-icon-theme \
        fluent-gtk-theme \
        ttf-roboto \
        noto-fonts \
        noto-fonts-cjk \
        noto-fonts-emoji \
        noto-fonts-extra \
        cantarell-fonts \
        awesome-terminal-fonts \
        ttf-fira-code \
        ttf-firacode-nerd \
        ttf-nerd-fonts-symbols \
        ttf-opensans \
        ttf-hack \
        ttf-ms-fonts \
        ttf-ms-win11-auto \
        ttf-all-the-icons \
        otf-font-awesome \
        adobe-source-han-sans-otc-fonts \
        papirus-folders
}

# Check if a package is installed
is_pkg_installed() {
    pacman -Qi "$1" &> /dev/null
}

purge_base_noise_packages() {
    local pkgs_to_remove=(
        cpupower
        micro
        vim
        cachyos-zsh-config
        cachyos-fish-config
        cachyos-micro-settings
        meld
        alacritty
        btop
        octopi
    )

    local found_pkgs=()
    for pkg in "${pkgs_to_remove[@]}"; do
        if is_pkg_installed "$pkg"; then
            found_pkgs+=("$pkg")
        fi
    done

    if [ ${#found_pkgs[@]} -gt 0 ]; then
        sudo pacman -Rs --noconfirm "${found_pkgs[@]}"
    else
        info "No 'noise' packages found to purge. Skipping."
    fi
}

install_laptop_packages() {
    sudo pacman -S --noconfirm \
        brightnessctl \
        blueman \
        tlp \
        tlp-pd \
        tlp-rdw \
        acpi
}
