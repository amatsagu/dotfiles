#!/usr/bin/env bash

optimize_for_laptop() {
    sudo systemctl enable --now tlp.service
    sudo systemctl enable --now tlp-pd.service
    sudo systemctl enable --now bluetooth.service
    sudo systemctl enable NetworkManager-dispatcher.service
    sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
    sudo sed -i 's/#AutoEnable=false/AutoEnable=true/' /etc/bluetooth/main.conf

    warning "Installed custom services (TLP + TLP-PD) which will auto-tune battery usage and provide power profiles."
}

assign_environmental_variables_to_profile() {
    local PROFILE_DATA=$(cat <<'EOF'

# Environment variables for theme, wayland & sway proper execution
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export DESKTOP_SESSION=sway
export MOZ_ENABLE_WAYLAND=1
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland
export GDK_BACKEND="wayland,x11"
export GTK_BACKEND="wayland"
export GTK_CSD=0
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME=kvantum
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export TERMINAL="foot"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"

# GPU & VM Compatibility
case "$(systemd-detect-virt)" in
  qemu|kvm|oracle)
    export WLR_RENDERER=pixman
    export WLR_NO_HARDWARE_CURSORS=1
    ;;
esac

# Nvidia Specifics (Still required for stability)
if [ -d /sys/module/nvidia ]; then
    export WLR_NO_HARDWARE_CURSORS=1
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export LIBVA_DRIVER_NAME=nvidia
fi

# Auto start Sway from tty1 after login
if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
    # Check for Nvidia and launch with proper flags if needed
    if [ -d /sys/module/nvidia ]; then
        exec systemd-cat -- sway --unsupported-gpu
    else
        exec systemd-cat -- sway
    fi
fi

EOF
)

    echo "$PROFILE_DATA" >> ~/.bash_profile
}
# Check for display EDID profiles and offer Sway 1.12+ color enhancement
check_display_color_capabilities() {
    local edid_found=false
    local config_file="$HOME/.config/sway/config.d/theme_and_screen"

    # Check if any EDID is accessible via DRM sysfs (works in TTY)
    for edid_path in /sys/class/drm/card*-*/edid; do
        if [ -s "$edid_path" ]; then
            edid_found=true
            break
        fi
    done

    if [ "$edid_found" = true ]; then
        success "Hardware EDID color profiles detected!"
        if confirm "Sway 1.12+ can use EDID primaries for better color accuracy. Enable this for all your displays?"; then
            if [ -f "$config_file" ]; then
                # Update the existing 'output * scale' line to include the color profile
                sed -i 's/output \* scale $scale/output \* scale $scale color_profile --device-primaries/' "$config_file"
                success "Updated Sway config with --device-primaries."
            else
                error "Sway config not found at $config_file - skipping update."
            fi
        fi
    fi
}
