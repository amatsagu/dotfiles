#!/bin/bash

cat << EOF
# ===========================================================================
# STEP 2
# INSTALL SELECTED BROWSER
# ===========================================================================
EOF

if [ "$res_browser" == "google-chrome" ]; then
    wget -O ./GoogleChromeSetup.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo apt install ./GoogleChromeSetup.deb -y
    rm ./GoogleChromeSetup.deb
    sudo cp ./desktop/google-chrome.desktop /usr/share/applications/google-chrome.desktop
    xdg-settings set default-web-browser google-chrome.desktop
fi

if [ "$res_browser" == "firefox" ]; then
    curl -Ss https://packages.mozilla.org/apt/repo-signing-key.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/mozilla.gpg

    # local fp=$(gpg --quiet --no-default-keyring --keyring /etc/apt/trusted.gpg.d/mozilla.gpg --fingerprint | awk '/pub/{getline; gsub(/^ +| +$/,""); print "\n"$0"\n"}')

    # if [ "$fp" != "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3" ]; then
    #     echo "$red ERROR:$color_reset Acquired mozilla keyring is invalid! Script will skip installation of firefox for security reasons."
    #     sudo rm /etc/apt/trusted.gpg.d/mozilla.gpg
    #     exit 1
    # fi

    echo "deb [signed-by=/etc/apt/trusted.gpg.d/mozilla.gpg] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list
    sudo apt update
    sudo apt install firefox -y
    sudo cp ./desktop/firefox.desktop /usr/share/applications/firefox.desktop 
    xdg-settings set default-web-browser firefox.desktop
fi