source ./script/shared/logger.sh

echo -e " "
print_message warn "You're about to install and configure fingerprint scanner (for thinkpads at least) for '$USER' user."
echo -e "${NC}"
echo -e "Do you want to proceed? (yes/no)"
echo -e " "
read -r user_input
echo -e " "

if [[ "$user_input" != "yes" ]]; then
    print_message info "Script aborted by the user."
    exit 1
fi

print_message ok "User accepted the warning. Proceeding..."

print_message info "Installing required drivers & libs.."
sudo apt-get install fprintd libpam-fprintd -y >> /dev/null

# Allow swaylock to authenticate even when password is empty (when using fingerprint)
print_message info "Updating swaylock to accept authentication via fingerprint (press enter and try scanning on next login)..."
sed -i '/ignore-empty-password/d' ~/.config/swaylock/config >> /dev/null
echo "auth sufficient pam_unix.so try_first_pass likeauth nullok" | sudo tee -a /etc/pam.d/swaylock >> /dev/null
echo "auth sufficient pam_fprintd.so" | sudo tee -a /etc/pam.d/swaylock >> /dev/null

print_message ok "Successfully installed fingerprint scanner components & enabled it as authentication method for lock screen."
print_message warn "Starting fingerprint registration process. Please tap scanner few times under different positions, follow feedback in terminal:"

sudo fprintd-enroll "$USER"
sudo pam-auth-update

print_message ok "Successfully added fingerprint scanning as authentication method for $USER user."