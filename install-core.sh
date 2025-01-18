source ./script/shared/logger.sh

echo -e " "
print_message warn "Proceeding with this installation will overwrite a lot of existing configurations. This custom, Sway/Owl installation relies on newer packages from Debian 13 (Trixie) so if you use version 12 - we'll try to force upgrade your repositories. This operation is somewhat dangerous and if fails - your system may end in unrecoverable state."
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

source ./script/shared/upgrade-trixie.sh
exec try_trixie_upgrade

print_message info "Upgrading system packages... (can take a while)"
exec upgrade_system_packages

source ./script/core/01-core.sh
exec install_microcode
exec install_base_packages
exec install_audio_packages
exec try_install_bluetooth_packages
exec try_install_brightnessctl
print_message ok "Installed all basic packages. From this point, you should see working network, bluetooth, audio, etc."

source ./script/core/02-sway.sh
exec install_sway_packages
print_message ok "Installed all sway related packages, essential apps and portals. Sway is already working, next step will theme it."

source ./script/core/03-theme.sh
exec install_cursors
exec install_icons
exec install_gtk_theme
exec install_font_packages
source ./script/shared/gsettings.sh
exec apply_gsettings
mkdir ~/.config -p >> /dev/null
cp ./config/* ~/.config -r >> /dev/null
chmod +x ~/.config/swaylock/lock.sh >> /dev/null
print_message ok "Installed & applied all visual modifications."

print_message info "It's recommended to make full system restart. After rebooting - you can type 'sway' in tty to start sway session."