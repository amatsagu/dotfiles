#!/bin/bash

try_install_fingerprint_support() {
    print_message warn "Proceeding with installation & initial configuration of finterprint scanner driver."
    print_message warn "Please only accept if your device does has fingerprint sensor and you wish to use it."
    echo -e "${NC}"
    echo -e "Do you want to proceed? (yes/no)"
    echo -e " "
    read -r user_input_fsc
    echo -e " "

    if [[ "$user_input_fsc" == "yes" ]]; then
        print_message ok "User accepted installation. Proceeding..."

        print_message info "Installing required drivers & libs.."
        sudo apt-get install fprintd libpam-fprintd -y >> /dev/null

        # Allow swaylock to authenticate even when password is empty (when using fingerprint)
        sed -i '/ignore-empty-password/d' ~/.config/swaylock/config

        # Add fingerprint as viable login method to swaylock
        echo "auth sufficient pam_unix.so try_first_pass likeauth nullok" | sudo tee -a /etc/pam.d/swaylock
        echo "auth sufficient pam_fprintd.so" | sudo tee -a /etc/pam.d/swaylock

        print_message ok "Successfully installed fingerprint scanner components & enabled it as authentication method for lock screen."
        print_message warn "Starting fingerprint registration process. Please tap scanner few times under different positions, follow feedback in terminal:"
        
        local username
        username=$(whoami)
        sudo fprintd-enroll "$username"
        sudo pam-auth-update

        print_message ok "Successfully added fingerprint scanning as authentication method for $username user."
    fi
}