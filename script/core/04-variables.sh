#!/bin/bash

assign_environmental_variables_to_profile() {
    print_message info "Adding theme, wayland & sway specific env variables (at ~/.profile)..."

    PROFILE_DATA=$(cat <<'EOF'

# Environment variables for theme, wayland & sway proper execution
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export QT_QPA_PLATFORM=wayland
export GTK_CSD=0

# Auto start sway from tty1 after login
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi

EOF
)

    echo "$PROFILE_DATA" >> "~/.profile"
}