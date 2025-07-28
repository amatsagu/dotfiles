#!/usr/bin/env bash

optimize_for_laptop() {
    sudo systemctl enable --now tlp.service
    sudo systemctl enable --now bluetooth.service
    sudo sed -i 's/#AutoEnable=false/AutoEnable=true/' /etc/bluetooth/main.conf

    warning "Installed custom services which will auto-tune battery usage in real time and notify you when battery is low (<15%)."
}

assign_environmental_variables_to_profile() {
    local PROFILE_DATA = $(cat <<'EOF'

# Environment variables for theme, wayland & sway proper execution
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export DESKTOP_SESSION=sway
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME=qt5ct
export GTK_CSD=0
export GDK_BACKEND="wayland,x11"
export GTK_BACKEND="wayland"
export CLUTTER_BACKEND=wayland
export _JAVA_AWT_WM_NONREPARENTING=1 # Java xwayland blank screen fix
export TERMINAL="foot"
export SSH_AUTH_SOCK

# Check if system is running in virtual machine
case "$(systemd-detect-virt)" in
qemu)
  export WLR_RENDERER=pixman
  export WLR_NO_HARDWARE_CURSORS=1
  ;;
kvm)
  export WLR_NO_HARDWARE_CURSORS=1
  ;;
oracle)
  export WLR_NO_HARDWARE_CURSORS=1
  ;;
esac

# Apply Nvidia-specific variables
if [ -d /sys/module/nvidia ] && [ ! -d /sys/module/amdgpu ] && [ ! -d /sys/module/i915 ]; then
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