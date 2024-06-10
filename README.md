<h1 align=center>Amatsagu Dotfiles</h1>

<div align="center">
<a href="#gallery">Gallery</a> - <a href="#install">Install</a> - <a href="#usage">Usage</a> - <a href="#credit">Credit</a>
<br>
┗━ <a href="https://www.reddit.com/r/unixporn/comments/1d9r6a8/sway_like_falling_petals_and_flowing_water/">See reddit thread</a> ━┛
</div>

<h1></h1>

<img src=".github/logo.png" alt="img" align="right" width="350px">

- Linux distro - **Debian 12**
- Tiling manager - **Sway**
- GTK theme - **Adwaita (dark)**
- Icon theme - **Papirus (dark)**
- Cursor theme - **Phinger cursors (dark)**
- Color theme - **Gnome shell**
- Fonts - **Noto Sans, Awesome Fonts, Roboto, FiraCode**
- Terminal - **Foot**
- Text editor - **Nano**
- File manager - **Nemo**
- Status bar - **Waybar**
- App menu - **Fuzzel**
- Notifications - **Mako**
- Session control - **Wlogout**
- Audio server - **Pipewire** + **Pavucontrol**
- Bluetooth manager - **Blueman**
- Connection manager - **Network manager**

## Gallery
![desktop](.github/1.png)
<br><br>
![floating windows](.github/2.png)
<br><br>
![terminal colors and notification](.github/3.png)
<br><br>
![multi window tiling mode](.github/4.png)
<br><br>
![single, full screen window mode](.github/5.png)

## Install

This installation script is built to hopefully make the installation process easier for you. I cannot guarantee that it will work; you may run into issues. If something is missing and/or doesn't work, I would recommend reading over the installation script. Keep in mind that those dotfiles were created primarily for my usage so it's expected you'll want to check `.config/sway` config to set valid screen scale for your monitor or change some keybinds (I use mostly default ones).

Now, if you use other distro than Debian 12 (bookworm), you're out of luck - you can still make it work but you'll need to open [setup/packages.sh](https://github.com/amatsagu/dotfiles/blob/master/setup/packages.sh) script and manually install all used themes, fonts & apps. For Debian users, there's automatic script to assist you - install fresh system with just minimal packages (uncheck gnome or any other desktop during installation), clone this repository & run installation script; feel free to copy & paste below commands:
```sh
sudo apt update && sudo apt upgrade -y
sudo apt install git -y
git clone https://github.com/amatsagu/dotfiles.git
cd ./dotfiles
chmod +x ./install.sh
./install.sh
```
After that, just type `sway` to enter your new desktop :)
