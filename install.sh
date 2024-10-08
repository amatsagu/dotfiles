#!/bin/bash

# Define ASCI colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Define a temporary file to store command output
temp_output=$(mktemp)

print_message() {
    local log_type="$1"
    local message="$2"

    case "$log_type" in
        ok)
            echo -e "${GREEN}[OK] $message${NC}"
            ;;
        warn)
            echo -e "${YELLOW}[WARN] $message${NC}"
            ;;
        error)
            echo -e "${RED}[ERROR] $message${NC}"
            ;;
        *)
            echo -e "${NC}[INFO] $message"
            ;;
    esac
}

print_error_output() {
    while IFS= read -r line; do
        echo -e "${RED}${line}${NC}"
    done < "$temp_output"
}

# Function to execute a command and handle errors
exec() {
    local command="$1"
    eval "$command" 2>> "$temp_output"

    if [ $? -ne 0 ]; then
        print_message error "Failed to execute '$command' command:"
        print_error_output
        rm "$temp_output"
        exit 1
    fi
}

print_message warn "Proceeding with this installation will overwrite a lot of existing configurations. This custom, Sway installation relies on newer packages from Debian 13 (Trixie) so if you use version 12 - we'll try to force upgrade your repositories. This operation is somewhat dangerous and if fails - your system may end in unrecoverable state."
echo -e "${NC}"
echo -e "Do you want to proceed? (yes/no)"
echo -e " "
read -r user_input
echo -e " "

# Check user input
if [[ "$user_input" != "yes" ]]; then
    print_message info "Installation aborted by the user."
    exit 1
fi

print_message ok "User accepted the warning. Proceeding with installation..."
chmod +x ./setup/*.sh
source ./setup/01-trixie.sh
source ./setup/02-packages.sh
source ./setup/03-sway.sh
source ./setup/04-theme.sh
source ./setup/05-applications.sh

# Execute all major scripts
detect_trixie
detect_cpu_vendor
exec install_base_packages
exec install_flathub_support
exec install_sway_packages
mkdir ~/.config >> /dev/null
cp -r ./config/* ~/.config
chmod +x ~/.config/swaylock/lock.sh
exec apply_fonts
exec apply_theme
exec try_install_programming_languages
exec try_install_web_browsers
exec try_install_spotify
exec try_install_nerd_packages

# Clean up the temporary file
rm "$temp_output"

print_message ok "Successfully finished this custom sway installation. It's recommended to restart your computer. Type 'sway' in tty to start sway session."