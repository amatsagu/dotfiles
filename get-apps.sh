source ./script/shared/logger.sh

# Included here are only apps, languages or libraries that have specific way to get them working on wayland.
# Any other apps like Firefox or Deluge should be normally installed as is.
INSTALL_APPS=(
    "termius"
    "vsc" # Microsoft's Visual Studio Code
)

# There's also included way to properly remove all "custom" apps that were previously installed by this script.
# Move items from higher list into this list to uninstall them instead.
UNINSTALL_APPS=(

)

echo -e " "
print_message warn "You're about to un/install higher mentioned apps & edit their .desktop files to force use wayland ozone layer. You can edit this script to edit list of apps you wish to install."
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

for app in "${INSTALL_APPS[@]}"; do
    path="./script/app/install/${app}.sh"
    if [ -f "$path" ]; then
        source "$path"
    else
        print_message warn "Entry '$app' at apps to install is invalid. Skipping!"
    fi
done

for app in "${UNINSTALL_APPS[@]}"; do
    path="./script/app/uninstall/${app}.sh"
    if [ -f "$path" ]; then
        source "$path"
    else
        print_message warn "Entry '$app' at apps to remove is invalid. Skipping!"
    fi
done