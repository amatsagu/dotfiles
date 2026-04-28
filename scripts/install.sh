#!/usr/bin/env bash

## -- GLOBAL CONFIG -- ##
IGNORE_ERRORS=false
IS_CACHY=false
KBD_LAYOUT="us"
SCREEN_SCALE="1"

source ./scripts/shared/terminal.sh
source ./scripts/shared/packages.sh
source ./scripts/shared/style.sh
source ./scripts/shared/optional.sh

main() {
    # Verify Arch-based system
    if [ ! -f /etc/arch-release ]; then
        error "This script is designed for Arch Linux and its derivatives. Installation aborted."
        exit 1
    fi

    # Detect CachyOS for specialized optimizations
    grep -q "CachyOS" /etc/os-release && IS_CACHY=true

    if [ "$IS_CACHY" = false ]; then
        warning "You're not running CachyOS. This script was originally built for it."
        confirm "Proceed anyway with general Arch installation?" || exit 0
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

    # Keyboard Layout Selection
    question "Enter your preferred keyboard layout (e.g., us, pl, de)"
    echo -n " [Default: $KBD_LAYOUT]: "
    read -r input_kbd
    if [ -n "$input_kbd" ]; then
        if localectl list-x11-keymap-layouts | grep -qw "$input_kbd"; then
            KBD_LAYOUT="$input_kbd"
            success "Keyboard layout set to: $KBD_LAYOUT"
        else
            warning "Layout '$input_kbd' not found. Falling back to default: $KBD_LAYOUT"
        fi
    fi

    # Screen Scaling Selection
    question "Enter your preferred screen scaling (float number, e.g., 1, 1.25, 1.5)"
    echo -n " [Default: $SCREEN_SCALE]: "
    read -r input_scale
    if [ -n "$input_scale" ]; then
        if [[ "$input_scale" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            SCREEN_SCALE="$input_scale"
            success "Screen scaling set to: $SCREEN_SCALE"
        else
            warning "Invalid scale '$input_scale'. Falling back to default: $SCREEN_SCALE"
        fi
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
    run_command "install_dotfiles" "Installing dotfiles... (can take a while)" "Check permissions or manually run 'install_dotfiles' from scripts/shared/style.sh"
    
    # Run color check now that configs are in place
    check_display_color_capabilities

    run_command "apply_gsettings" "Updating style rules for GTK..." "Manually run 'apply_gsettings' from scripts/shared/style.sh"
    run_command "apply_qt_settings" "Updating style rules for QT..." "Manually run 'apply_qt_settings' from scripts/shared/style.sh"

    info "Step [ 3/3 ] :: Select optional enhancements:"
    confirm "Add \"launch script\" code into ~/.bash_profile that will automatically help solve common wayland problems + auto start Sway from tty1 on new session?" false && {
        run_command "assign_environmental_variables_to_profile" "Adding launch script code into local user bash profile..." "Manually append the PROFILE_DATA from scripts/shared/optional.sh to your ~/.bash_profile"
    }

    confirm "Optimize for laptops? (installs potentially missing packages, enabled tlp & bluetooth)" false && {
        run_command "install_laptop_packages" "Downloading extra packages for laptops..." "Try installing brightnessctl, blueman, tlp manually"
        run_command "optimize_for_laptop" "Optimizing..." "Check 'optimize_for_laptop' in scripts/shared/optional.sh"
    }


    info "Finalizing..."
    if [ "$IS_CACHY" = true ]; then
        run_command "purge_base_noise_packages" "Purging base CachyOS 'noise' packages..."
    fi

    # May be needed to let user control screen brightness in rare cases
    sudo usermod -a -G video $USER
    
    # Final message
    echo
    success "Installation completed successfully!"
    info "You may need to reboot for all changes to take effect"
}

main
