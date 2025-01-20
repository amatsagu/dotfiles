#!/bin/bash

install_microcode() {
    print_message info "Installing microcode for your CPU..."
    local proc_type=$(lscpu | grep "Vendor ID")

    if grep -qE "GenuineIntel" <<< ${proc_type}; then
        print_message info "Installing Intel microcode..."
        sudo apt-get install intel-microcode -y >> /dev/null
    elif grep -qE "AuthenticAMD" <<< ${proc_type}; then
        print_message info "Installing AMD microcode..."
        sudo apt-get install amd64-microcode -y >> /dev/null
    else
        print_message error "Unsupported CPU vendor. Aborting installation."
        exit 1
    fi
}

install_base_packages() {
    print_message info "Installing essential packages..."

    # Utility, core packages
    sudo apt-get install \
        zip \
        curl \
        wget \
        apt-transport-https \
        network-manager \
        network-manager-gnome \
        rfkill \
        gpg \
        p7zip-full \
        git \
        webp \
        nano \
        imagemagick \
        libadwaita-1-0 \
        libgtk-3-0 \
        libglib2.0-0 \
        libglib2.0-bin \
        libnotify-bin \
        libsass1 \
        sassc \
        polkitd \
    -y >> /dev/null
}

install_audio_packages() {
    print_message info "Installing audio packages..."

    sudo apt-get install \
        pipewire \
        pipewire-pulse \
        pipewire-bin \
        pipewire-alsa \
        pipewire-jack \
        pipewire-audio-client-libraries \
        pipewire-audio \
        wireplumber \
        pavucontrol \
        pamixer \
        ffmpeg \
        libpipewire-0.3-0t64 \
        gstreamer1.0-pipewire \
	    gstreamer1.0-pulseaudio \
	    gstreamer1.0-plugins-good \
	    gstreamer1.0-plugins-bad \
	    gstreamer1.0-plugins-base \
    -y >> /dev/null

    print_message info "Launching audio service(s)..."
    systemctl --user --now enable pipewire pipewire-pulse >> /dev/null
    systemctl --user daemon-reload >> /dev/null
}

try_install_bluetooth_packages() {
    if [ -d "/sys/class/bluetooth" ]; then
        print_message info "Detected bluetooth support. Installing bluetooth specific packages..."

        sudo apt-get install blueman bluez libspa-0.2-bluetooth -y >> /dev/null
        sudo apt-get purge pulseaudio-module-bluetooth -y >> /dev/null
        sudo systemctl enable bluetooth.service >> /dev/null
    else
        print_message info "Failed to detect bluetooth support. Skipping bluetooth specific packages installation!"
    fi
}

try_install_brightnessctl() {
    if [ -d "/sys/class/backlight" ]; then
        print_message info "Detected screen brightness support. Installing brightnessctl package..."

        sudo apt-get install brightnessctl -y >> /dev/null
    else
        print_message info "Failed to detect screen brightness support. Skipping brightnessctl package installation!"
    fi
}