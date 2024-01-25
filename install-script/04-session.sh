cat << EOF
# ===========================================================================
# STEP 4
# APPLY SESSION CONTROL PREFERENCES
# ===========================================================================
EOF

if [ "$res_autologin" == "y" ]; then
    echo ""  >> /home/$user/.profile
    echo "#Auto start sway with lockscreen" >> /home/$user/.profile
    echo "sway" >> /home/$user/.profile
fi

if [ "$res_xwayland" == "y" ]; then
    sudo apt install xwayland -y
fi