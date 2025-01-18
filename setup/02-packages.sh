#!/bin/bash

detect_cpu_vendor() {
    local proc_type=$(lscpu)

    if grep -E "GenuineIntel" <<< ${proc_type}; then
        print_message info "Installing Intel microcode..."
        exec install_intel_microcode
    elif grep -E "AuthenticAMD" <<< ${proc_type}; then
        print_message info "Installing AMD microcode..."
        exec install_amd_microcode
    else
        print_message error "Unsupported CPU vendor. We'll continue installation but please be aware things are untested for your CPU - it may result in bugged experience."
    fi
}

install_intel_microcode() {
    sudo apt-get install intel-microcode -y >> /dev/null
}

install_amd_microcode() {
    sudo apt-get install amd64-microcode -y >> /dev/null
}

install_base_packages() {
    print_message info "Installing base packages..."

    sudo apt-get update >> /dev/null

    # Packages used for common operations or to provide basic functionality
    sudo apt-get install htop zip curl wget apt-transport-https network-manager rfkill fastfetch gpg brightnessctl pipewire pipewire-audio-client-libraries pavucontrol pamixer -y >> /dev/null

    # Try to add bluetooth support
    if sudo rfkill list | grep -iq "Bluetooth"; then
        sudo apt-get install blueman libspa-0.2-bluetooth -y >> /dev/null
        sudo apt purge pulseaudio-module-bluetooth -y >> /dev/null
        sudo systemctl enable bluetooth.service
    fi

    # Add extra applications that either extends common package or adds graphical interface
    sudo apt-get install network-manager-gnome pavucontrol imagemagick -y >> /dev/null

    # Add required libs
    sudo apt-get install libgtk-3-0 libglib2.0-0 libglib2.0-bin libnotify-bin libsass1 sassc -y >> /dev/null

    # Add misc support, portals
    sudo apt-get install xdg-desktop-portal-wlr xdg-desktop-portal-gtk -y >> /dev/null

    # Enable audio service(s)
    print_message info "Launching audio service(s)..."
    systemctl --user --now enable pipewire pipewire-pulse >> /dev/null
    systemctl --user daemon-reload >> /dev/null

    print_message ok "Successfully installed all base packages."
}

install_flathub_support() {
    print_message info "Adding support for flatpak... (registering flathub repository)"

    sudo apt-get install flatpak -y >> /dev/null
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >> /dev/null
    # sudo systemctl restart flatpak-system-helper >> /dev/null

    print_message ok "Successfully added flathub repositories. You may need to restart your system to see all changes."
}
