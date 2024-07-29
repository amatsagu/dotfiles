#!/bin/bash

# Function to check the current Debian version and upgrade if needed
detect_trixie() {
    local version_codename
    version_codename=$(grep "VERSION_CODENAME" /etc/os-release | cut -d '=' -f 2)

    case "$version_codename" in
        "bookworm")
            print_message ok "Detected Debian 12 (bookworm). Preparing to upgrade..."
            print_message info "Detected Debian 12 (bookworm). Upgrading to Debian 13 (trixie)..."
            exec upgrade_to_trixie
            ;;
        "trixie")
            print_message ok "Detected Debian 13 (trixie). No upgrade necessary."
            exec upgrade_to_trixie
            ;;
        *)
            print_message error "Unsupported Debian version codename: $version_codename. Aborting."
            exit 1
            ;;
    esac
}

upgrade_to_trixie() {
    print_message info "Backing up sources.list... (at /etc/apt/sources.list.backup)"
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup >> /dev/null
    sudo cp /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.list.backup 2> /dev/null || true

    print_message info "Updating current system..."
    sudo apt-get update >> /dev/null
    sudo apt-get upgrade -y >> /dev/null
    sudo apt-get full-upgrade -y >> /dev/null
    sudo apt autoremove --purge -y >> /dev/null
    sudo apt-get clean >> /dev/null

    print_message info "Updating sources.list to Trixie versioning..."
    sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list >> /dev/null
    sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list.d/*.list 2> /dev/null || true

    print_message info "Upgrading to Debian 13 (Trixie)..."
    sudo apt-get update >> /dev/null
    sudo apt-get upgrade -y >> /dev/null
    sudo apt-get full-upgrade -y >> /dev/null
    sudo apt autoremove --purge -y >> /dev/null
    sudo apt-get clean >> /dev/null

    print_message info "Fixing (potentially) broken packages..."
    sudo apt --fix-broken install -y

    print_message info "Cleaning up backup files..."
    sudo rm -f /etc/apt/sources.list.backup >> /dev/null
    sudo rm -f /etc/apt/sources.list.d/*.list.backup 2> /dev/null || true

    print_message ok "Upgrade process completed successfully."
    print_message warn "Full system restart after installation process is highly recommended."
}