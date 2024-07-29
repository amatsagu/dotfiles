#!/bin/bash

install_sway_packages() {
    print_message info "Installing sway packages..."

    # Packages used for common operations or to provide basic functionality
    sudo apt-get sway waybar wlogout swaylock swayidle swaybg mako-notifier -y >> /dev/null

    # Install basic applications & tools that cannot be installed from flathub
    print_message info "Installing basic applications & tools..."
    sudo apt-get install fuzzel grim slurp nemo totem -y >> /dev/null

    
    # Install basic set of GNOME applications


}