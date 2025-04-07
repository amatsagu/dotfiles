source ./script/shared/logger.sh

if ! grep -q "CachyOS" /etc/os-release; then
    print_message error "You're not running CachyOS Linux distro. This script is prepared & tested specifically for CachyOS. Installation aborted."
    exit 1
fi

if [[ "$(basename "$SHELL")" != "bash" ]]; then
    print_message error "This script is supposed to run using bash. Default zsh configuration will be removed. Please change default shell and restart before you continue: chsh -s /usr/bin/bash"
    exit 1
fi

echo -e " "
print_message warn "Proceeding with this installation will overwrite a lot of existing configurations. This operation is somewhat dangerous and if fails - your system may end in unrecoverable state."
echo -e "${NC}"
echo -e "Do you want to proceed? (yes/no)"
echo -e " "
read -r user_input
echo -e " "

if [[ "$user_input" != "yes" ]]; then
    print_message info "Installation aborted by the user."
    exit 1
fi

print_message ok "User accepted the warning. Proceeding with installation..."

print_message info "Searching & auto updating system packages... (can take a while)"
source ./script/shared/cachyos.sh
exec refresh_keyrings
exec update_system

source ./script/core/01-core.sh
exec install_base_packages
exec purge_base_noise_packages
print_message ok "Installed all basic packages. From this point, you should see working network, bluetooth, audio, etc."
print_message info "Your audio, network, bluetooth, laptop specific packages are handled by CachyOS Hello packages, script does not touch those elements."

source ./script/core/02-sway.sh
exec install_sway_packages
print_message ok "Installed all sway related packages, essential apps and portals. Sway is already working, next step will theme it."

source ./script/core/03-theme.sh
exec install_theme_packages
exec install_wallpapers
source ./script/shared/gsettings.sh
exec apply_gsettings
mkdir ~/.config -p >> /dev/null
cp ./config/* ~/.config -r >> /dev/null
chmod +x ~/.config/sway/script/* >> /dev/null
print_message ok "Installed & applied all visual modifications."
source ./script/core/04-variables.sh
exec assign_environmental_variables_to_profile

print_message info "It's recommended to make full system restart. After rebooting - you can type 'sway' in tty to start sway session."