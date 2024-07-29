#!/bin/bash

detect_cpu_vendor() {
    local proc_type=$(lscpu)
    print_message ok "Detected system with $proc_type CPU vendor."

    case "$version_codename" in
        "GenuineIntel")
            print_message info "Installing Intel microcode..."
            exec install_intel_microcode
            ;;
        "AuthenticAMD")
            print_message info "Installing AMD microcode..."
            exec install_amd_microcode
            ;;
        *)
            print_message error "Unsupported CPU vendor: $version_codename. We'll continue installation but please be aware things are untested for your CPU - it may result in bugged experience."
            ;;
    esac
}

install_intel_microcode() {
    sudo apt-get install intel-microcode -y >> /dev/null
}

install_amd_microcode() {
    sudo apt-get install amd64-microcode -y >> /dev/null
}

install_base_packages() {
    print_message info "Installing base packages..."

    # Packages used for common operations or to provide basic functionality
    sudo apt-get install htop zip curl wget network-manager rfkill fastfetch gpg brightnessctl pipewire pipewire-audio-client-libraries pamixer -y >> /dev/null

    # Try to add bluetooth support
    if sudo rfkill list | grep -iq "Bluetooth"; then
        sudo apt-get install blueman -y >> /dev/null
    fi

    # Add extra applications that either extends common package or adds graphical interface
    sudo apt-get install network-manager-gnome pavucontrol -y >> /dev/null

    # Add required libs
    sudo apt-get install libgtk-3-0 libglib2.0-0 libglib2.0-bin libnotify-bin -y >> /dev/null

    # Enable audio service(s)
    print_message info "Launching audio service(s)..."
    systemctl --user --now enable pipewire pipewire-pulse >> /dev/null
    systemctl --user daemon-reload >> /dev/null

    print_message ok "Successfully installed all base packages."
}

install_fluthub_support() {
    print_message info "Adding support for flatpak... (registering flathub repository)"
    
    sudo apt-get flatpak -y >> /dev/null
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >> /dev/null
    sudo systemctl restart flatpak-system-helper >> /dev/null

    print_message ok "Successfully added flathub repositories. You may need to restart your system to see all changes."
}