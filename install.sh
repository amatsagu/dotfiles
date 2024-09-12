#!/bin/bash

# Define ASCI colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Define a temporary file to store command output
temp_output=$(mktemp)

print_banner() {
  echo -e " "
  echo -e "#=============================================="
  echo -e "# $1"
  echo -e "#=============================================="
  echo -e " "
}

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

print_banner "Environment 'Lushera' installation script"
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

# Disable currently enabled display manager if exists (someone could add it from archinstall...)
if systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm'; then
  print_message info "Disabling currently enabled display manager..."
  sudo systemctl disable --now $(systemctl list-unit-files | grep enabled | grep -E 'gdm|lightdm|lxdm|lxdm-gtk3|sddm|slim|xdm' | awk -F ' ' '{print $1}') >> /dev/null
fi

# Execute all major scripts
# detect_trixie # Checks if Debian 13 is present, otherwise upgrade to 13
detect_cpu_vendor
exec install_base_packages
exec install_flathub_support
exec install_sway_packages
mkdir ~/.config
cp -r ./config/* ~/.config
exec apply_fonts
exec apply_theme

# Clean up the temporary file
rm "$temp_output"