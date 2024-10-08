#!/bin/bash

try_install_programming_languages() {
    print_message warn "Proceeding with installation of development tools (VSCode, Golang, NodeJS, Java[21], Rust, Termius)."
    echo -e "${NC}"
    echo -e "Do you want to proceed? (yes/no)"
    echo -e " "
    read -r user_input_dev
    echo -e " "

    if [[ "$user_input_dev" == "yes" ]]; then
        print_message ok "User accepted installation. Proceeding..."

        print_message info "Registering Microsoft source list..."
        curl -sS https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/microsoft.gpg
        sudo install -D -o root -g root -m 644 /etc/apt/trusted.gpg.d/microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg >> /dev/null
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
        
        print_message info "Installing latest version of Visual Studio Code (stable)..."
        sudo apt-get update >> /dev/null
        sudo apt-get install code -y >> /dev/null

        print_message info "Modifying VSC entries to use wayland ozone layer... (at ~/.local/share/applications)"
        sudo cp ./setup/entries/code.desktop /usr/share/applications/code.desktop
        sudo cp ./setup/entries/code-url-handler.desktop /usr/share/applications/code-url-handler.desktop
        sudo cp ./setup/entries/code.desktop ~/.local/share/applications/code.desktop
        sudo cp ./setup/entries/code-url-handler.desktop ~/.local/share/applications/code-url-handler.desktop
        xdg-mime default code.desktop text/plain

        print_message info "Installing latest version of Golang programming language (stable)..."
        sudo apt-get install golang -y >> /dev/null

        print_message info "Installing latest version of NodeJS environment (LTS)..."
        sudo apt-get install nodejs -y >> /dev/null

        print_message info "Installing v21 of OpenJDK Java programming language..."
        sudo apt-get install openjdk-21-jdk -y >> /dev/null

        print_message info "Installing latest version of Rust programming language (stable)..."
        sudo apt-get install rust-all -y >> /dev/null

        print_message ok "Successfully installed mentioned development tools."
    fi
}

try_install_web_browsers() {
    print_message warn "Proceeding with installation of web browsers (Firefox ESR, Google Chrome)."
    echo -e "${NC}"
    echo -e "Do you want to proceed? (yes/no)"
    echo -e " "
    read -r user_input_web
    echo -e " "

    if [[ "$user_input_web" == "yes" ]]; then
        print_message ok "User accepted installation. Proceeding..."

        print_message info "Installing ESR version of Firefox..."
        sudo apt-get install firefox-esr -y >> /dev/null

        print_message info "Installing latest version of Google Chrome (stable)..."
        wget --quiet -O ~/GoogleChromeSetup.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" >> /dev/null
        sudo apt-get install ~/GoogleChromeSetup.deb -y >> /dev/null
        rm ~/GoogleChromeSetup.deb

        print_message info "Modifying Google Chrome entries to use wayland ozone layer... (at ~/.local/share/applications)"
        sudo cp ./setup/entries/google-chrome.desktop /usr/share/applications/google-chrome.desktop
        sudo cp ./setup/entries/google-chrome.desktop ~/.local/share/applications/google-chrome.desktop
        xdg-settings set default-web-browser google-chrome.desktop


        print_message ok "Successfully installed web browsers."
    fi
}

try_install_spotify() {
    print_message warn "Proceeding with installation of Spotify."
    echo -e "${NC}"
    echo -e "Do you want to proceed? (yes/no)"
    echo -e " "
    read -r user_input_spotify
    echo -e " "

    if [[ "$user_input_spotify" == "yes" ]]; then
        print_message ok "User accepted installation. Proceeding..."

        print_message info "Registering Spotify source list..."
        curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
        sudo install -D -o root -g root -m 644 /etc/apt/trusted.gpg.d/spotify.gpg /etc/apt/keyrings/packages.spotify.gpg >> /dev/null
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

        print_message info "Installing latest version of Spotify (stable)..."
        sudo apt-get update >> /dev/null
        sudo apt-get install spotify-client -y >> /dev/null

        print_message info "Modifying Spotify entries to use wayland ozone layer... (at ~/.local/share/applications)"
        sudo cp ./setup/entries/spotify.desktop /usr/share/applications/spotify.desktop
        sudo cp ./setup/entries/spotify.desktop ~/.local/share/applications/spotify.desktop

        print_message ok "Successfully installed Spotify."
    fi
}

# Those are for me specefically but maybe someone will want them ~ amatsagu
try_install_nerd_packages() {
    print_message warn "Proceeding with installation of nerd packages (Termius, Vesktop, Deluge, Deezer, Gimp v3 [BETA])."
    echo -e "${NC}"
    echo -e "Do you want to proceed? (yes/no)"
    echo -e " "
    read -r user_input_nerd
    echo -e " "

    if [[ "$user_input_nerd" == "yes" ]]; then
        print_message ok "User accepted installation. Proceeding..."

        print_message info "Installing latest version of Termius (stable)..."
        wget --quiet -O ~/TermiusSetup.deb "https://www.termius.com/download/linux/Termius.deb" >> /dev/null
        sudo apt-get install ~/TermiusSetup.deb -y >> /dev/null
        rm ~/TermiusSetup.deb

        print_message info "Modifying Termius entries to use wayland ozone layer... (at ~/.local/share/applications)"
        sudo cp ./setup/entries/termius-app.desktop /usr/share/applications/termius-app.desktop
        sudo cp ./setup/entries/termius-app.desktop ~/.local/share/applications/termius-app.desktop

        print_message info "Installing latest version of Vesktop..."
        wget --quiet -O ~/VesktopSetup.deb "https://vencord.dev/download/vesktop/amd64/deb" >> /dev/null
        sudo apt-get install ~/VesktopSetup.deb -y >> /dev/null
        rm ~/VesktopSetup.deb

        print_message info "Modifying Vesktop entries to use wayland ozone layer... (at ~/.local/share/applications)"
        sudo cp ./setup/entries/vesktop.desktop /usr/share/applications/vesktop.desktop
        sudo cp ./setup/entries/vesktop.desktop ~/.local/share/applications/vesktop.desktop

        print_message info "Installing latest version of Deluge (stable)..."
        sudo apt-get install deluge -y >> /dev/null

        print_message info "Installing latest version of Deezer (stable)..."
        wget --quiet -O ~/DeezerSetup.deb "https://github.com/aunetx/deezer-linux/releases/download/v6.0.150-1/deezer-desktop_6.0.150_amd64.deb" >> /dev/null
        sudo apt-get install ~/DeezerSetup.deb -y >> /dev/null
        rm ~/DeezerSetup.deb

        print_message info "Modifying Deezer entries to use wayland ozone layer... (at ~/.local/share/applications)"
        sudo cp ./setup/entries/deezer-desktop.desktop /usr/share/applications/deezer-desktop.desktop
        sudo cp ./setup/entries/deezer-desktop.desktop ~/.local/share/applications/deezer-desktop.desktop

        print_message info "Installing latest, unstable version of Gimp (BETA) [only current user]..."
        flatpak install --user https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref --assumeyes --noninteractive >> /dev/null
        
        print_message info "Updating fonts cache for Gimp (BETA) & all flathub applications (just in case)..."
        flatpak list --columns=application | xargs -I %s -- flatpak run --command=fc-cache %s -f -v
        
        print_message ok "Successfully installed nerd packages."
    fi
}