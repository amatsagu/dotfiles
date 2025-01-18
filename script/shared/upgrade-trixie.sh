#!/bin/bash

try_trixie_upgrade() {
    local codename

    if grep -q "^ID=debian" /etc/os-release; then
        codename=$(grep "^VERSION_CODENAME=" /etc/os-release | cut -d"=" -f2 | tr -d '"')
    else
        print_message error "Unsupported linux distro. Expected Debian. Aborting installation."
        exit 1
    fi

    case "$codename" in
        "buster")
            print_message error "Detected unsupported version of Debian. Install at least Debian 12 (bookworm) before you continue. Aborting installation."
            exit 1
            ;;
        "bullseye")
            print_message error "Detected unsupported version of Debian. Install at least Debian 12 (bookworm) before you continue. Aborting installation."
            exit 1
            ;;
        "bookworm")
            print_message info "Detected Debian 12 (bookworm). Upgrading to Debian 13 (trixie)... (can take a while)"
            upgrade_to_trixie
            ;;
        "trixie")
            print_message ok "Detected Debian 13 (trixie). No upgrade necessary."
            ;;
        *)
            print_message warn "Detected unsupported version of Debian with codename: $codename. You can continue but be ready prepared for things breaking!"
            echo -e "${NC}"
            echo -e "Do you want to proceed? (yes/no)"
            echo -e " "
            read -r user_codename_input
            echo -e " "

            if [[ "$user_codename_input" != "yes" ]]; then
                print_message info "Installation aborted by the user."
                exit 1
            fi
            ;;
    esac
}

upgrade_to_trixie() {
    print_message info "Backing up sources.list... (at /etc/apt/sources.list.backup)"
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup >> /dev/null
    sudo cp /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.list.backup 2> /dev/null || true

    print_message info "Updating current system..."
    upgrade_system_packages

    print_message info "Updating sources.list to Trixie versioning..."
    sudo sed -i "s/bookworm/trixie/g" /etc/apt/sources.list >> /dev/null
    sudo sed -i "s/bookworm/trixie/g" /etc/apt/sources.list.d/*.list 2> /dev/null || true

    print_message info "Upgrading to Debian 13 (Trixie)..."
    upgrade_system_packages

    print_message info "Fixing (potentially) broken packages..."
    sudo apt --fix-broken install -y

    print_message info "Cleaning up backup files..."
    sudo rm -f /etc/apt/sources.list.backup >> /dev/null
    sudo rm -f /etc/apt/sources.list.d/*.list.backup 2> /dev/null || true

    print_message ok "Upgrade process completed successfully."
    print_message warn "Full system restart after installation process is highly recommended."
}

upgrade_system_packages() {
    sudo apt-get update >> /dev/null
    sudo apt-get upgrade -y >> /dev/null
    sudo apt-get full-upgrade -y >> /dev/null
    sudo apt autoremove --purge -y >> /dev/null
    sudo apt-get clean >> /dev/null
}