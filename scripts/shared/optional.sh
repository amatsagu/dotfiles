#!/usr/bin/env bash

optimize_for_laptop() {
    sudo systemctl enable --now tlp.service
    sudo systemctl enable --now bluetooth.service
    sudo sed -i 's/#AutoEnable=false/AutoEnable=true/' /etc/bluetooth/main.conf

    warning "Installed custom services which will auto-tune battery usage in real time and notify you when battery is low (<15%)."
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
export SSH_AUTH_SOCK

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

# Run Sway under ssh-agent
run_sway() {
    exec systemd-cat -- /usr/bin/ssh-agent /usr/bin/sway $@
}

# Auto start sway from tty1 after login
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    # Check if Nvidia driver installed, start Sway and send output to the journal
    if [ -d /sys/module/nvidia ] && [ ! -d /sys/module/amdgpu ] && [ ! -d /sys/module/i915 ]; then
        run_sway --unsupported-gpu $@
    else
        run_sway
    fi
fi

EOF
)

    echo "$PROFILE_DATA" >> ~/.bash_profile
}