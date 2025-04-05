#!/bin/bash

refresh_keyrings() {
    sudo pacman-key --init >> /dev/null
    sudo pacman-key --populate archlinux cachyos >> /dev/null
    sudo pacman -Sy --noconfirm archlinux-keyring cachyos-keyring >> /dev/null
}

update_system() {
    sudo pacman -Syu --noconfirm >> /dev/null
    sudo pacman -Rns $(pacman -Qdtq) --noconfirm >> /dev/null
}