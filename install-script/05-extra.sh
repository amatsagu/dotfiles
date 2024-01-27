#!/bin/bash

cat << EOF
# ===========================================================================
# STEP 5
# HANDLE ALL EXTRA ELEMENTS
# ===========================================================================
EOF

if [ "$res_spotify" == "y" ]; then
    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt install apt-transport-https -y
    sudo apt-get update
    sudo apt-get install spotify-client -y
    sudo cp ./desktop/spotify.desktop /usr/share/applications/spotify.desktop
fi

if [ "$res_code" == "y" ]; then
    curl -sS https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/microsoft.gpg
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt install apt-transport-https -y
    sudo apt update
    sudo apt install code -y
    sudo cp ./desktop/code.desktop /usr/share/applications/code.desktop
    sudo rm /usr/share/applications/code-url-handler.desktop
    xdg-mime default code.desktop text/plain
fi

if [ "$res_go" == "y" ]; then
    local GOURLREGEX='https://dl.google.com/go/go[0-9\.]+\.linux-amd64.tar.gz'
    local url="$(wget -qO- https://golang.org/dl/ | grep -oP 'https:\/\/dl\.google\.com\/go\/go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1 )"
    local latest="$(echo $url | grep -oP 'go[0-9\.]+' | grep -oP '[0-9\.]+' | head -c -2 )"

    echo "$purple NOTE:$color_reset Downloading Go v$latest..."
    echo

    curl -sS $url -o ./go-pkg.tar.gz
    sudo tar -C /usr/local -xzf ./go-pkg.tar.gz
    rm ./go-pkg.tar.gz

    echo ""  >> /home/$trk/.profile
    echo "export GOPATH=~/go" >> /home/$trk/.profile && source /home/$trk/.profile
    echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> /home/$trk/.profile && source /home/$trk/.profile
fi

if [ "$res_js" == "node" ]; then
    echo "$purple NOTE:$color_reset Adding latest version of NVM script!"
    curl -sS https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh -o ./nvm.sh
    bash ./nvm.sh
    source /home/$trk/.bash_profile
    nvm install --lts
fi

if [ "$res_js" == "deno" ]; then
    curl -fsSL https://deno.land/install.sh | sh
fi

if [ "$res_js" == "bun" ]; then
    curl -fsSL https://bun.sh/install | bash
fi

if [ "$res_rs" == "y" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi