#!/bin/bash

cat << EOF
# ===========================================================================
# STEP 4
# APPLY SESSION CONTROL PREFERENCES
# ===========================================================================
EOF

if [ "$res_autologin" == "y" ]; then
    cat >> /home/$trk/.profile << EOL

    #Auto start sway with lockscreen
    if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
        exec sway $
    fi

    EOL

    echo ""  >> /home/$trk/.config/sway/config.d/autostart_applications
    echo "#Auto start sway with lockscreen"  >> /home/$trk/.config/sway/config.d/autostart_applications
    echo "swaylock -f -C ~/.config/swaylock/config" >> /home/$trk/.config/sway/config.d/autostart_applications
fi