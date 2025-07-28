#!/usr/bin/env bash

## -- GLOBAL CONFIG -- ##
IGNORE_ERRORS=false

source ./scripts/shared/terminal.sh
source ./scripts/shared/packages.sh
source ./scripts/shared/style.sh
source ./scripts/shared/optional.sh

main() {
    if ! grep -q "CachyOS" /etc/os-release; then
        error "You're not running CachyOS Linux distro. This script is prepared & tested specifically for CachyOS. Installation aborted."
        exit 1
    fi

    if [[ "$(basename "$SHELL")" != "bash" ]]; then
        error "This script is supposed to run using bash. Please change default shell and restart before you continue: chsh -s /usr/bin/bash"
        exit 1
    fi

    clear
    banner "< InkTide > dotfiles installer (experimental)" "CYAN"
    
    # Confirm installation
    if ! confirm "Proceeding with this installation will modify your system. This operation can be dangerous. Continue?"; then
        info "Installation cancelled by user"
        exit 0
    fi

    confirm "Ignore errors and continue?" false && IGNORE_ERRORS=true
    success "User accepted warning. Proceeding with installation..."
    
    info "Step [ 0/3 ] :: Checking system requirements"
    if ! command -v sudo &>/dev/null; then
        error "Sudo is not installed - cannot continue."
        exit 1
    fi
    
    run_command "sudo -v" "Checking sudo privileges" || {
        error "Failed to verify sudo access."
        exit 1
    }
    
    info "Step [ 1/3 ] :: Downloading & installing packages:"
    run_command "install_base_packages" "Downloading base packages..."
    run_command "install_sway_packages" "Downloading Sway WM specific packages..."
    run_command "install_theme_packages" "Downloading theme preferences, fonts & icons..."
    
    info "Step [ 2/3 ] :: Starting main installation process:"
    run_command "install_dotfiles" "Installing dotfiles... (can take a while)"
    run_command "apply_gsettings" "Updating style rules for GTK..."

    info "Step [ 3/3 ] :: Select optional enhancements:"
    confirm "Add \"launch script\" code into ~/.bash_profile that will automatically help solve common wayland problems + auto start Sway from tty1 on new session?" false && {
        run_command "assign_environmental_variables_to_profile" "Adding launch script code into local user bash profile..."
    }

    confirm "Optimize for laptops? (installs potentially missing packages, enabled tlp & bluetooth)" false && {
        run_command "install_laptop_packages" "Downloading extra packages for laptops..."
        run_command "optimize_for_laptop" "Optimizing..."
    }


    info "Finalizing..."
    grep -q "CachyOS" /etc/os-release && {
        run_command "purge_base_noise_packages" "Purging some base CachyOS packages (debloating)..."
    }

    # May be needed to let user control screen brightness in rare cases
    sudo usermod -a -G video $USER
    
    # Final message
    echo
    success "Installation completed successfully!"
    info "You may need to reboot for all changes to take effect"
}

main