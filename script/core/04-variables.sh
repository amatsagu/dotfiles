#!/bin/bash

assign_environmental_variables_to_profile() {
    print_message info "Adding theme, wayland & sway specific env variables (at ~/.profile)..."

    PROFILE_DATA=$(cat <<'EOF'

# Environment variables for theme, wayland & sway proper execution
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME=qt5ct
export GTK_CSD=0
export _JAVA_AWT_WM_NONREPARENTING=1 # Java xwayland blank screen fix


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

    echo "$PROFILE_DATA" >> ~/.profile
}