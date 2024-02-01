# Secure installation of Arch Linux
This document will shortly instruct you how to greatly increase your system security without sacrificing on its ease of use.

> [!NOTE]  
> There's myth that Linux is so secure by default or that there's almost no viruses for this system - **wrong!** Chance of being infected on basic Linux installation is actually higher that on Windows or MacOS.

> [!IMPORTANT]  
> Below instructions will make your Arch Linux resistant to majority of attacks but it won't be invincible. After applying below steps, weakest part of your system will be you - always be careful when working with Arch's AUR, opening ports, etc.

## Preparation
1. Take your trusty laptop or other machine you want to use and disable secure bot, clear/reset secure boot keys & make it only use UEFI.
2. Enable administrator password that will be required to enter your bios.
3. Prepare USB pendrive with latest [Arch Linux ISO](https://archlinux.org/download/). It's recommended to use Rufus for Windows or Fedora Media Writer for Windows/Linux. If it aks you which mode to use - select DD image.
4. Boot with your pendrive.

## System installation
1. Wipe entire disk data. You can find your disk name with `lsblk` command. Then type `dd if=/dev/zero of=/dev/<your_disk> status=progress`
    * This process can take a longer while so please wait. It will return "error" message once it runs out of space to write more zeros. That means your entire disk got written which is great.
    * **Warning!** This process will delete anything you had on your disk! Make sure you have backup of all your important files.
2. Use `archinstall` command. We want to ensure it will make minimal installation with encypted disk (LUKS2), Unified Kernel Image(s) (UKI), and no swap (it won't work anyway), systemd-boot, and pipewire audio. Any other option like localization, keyboard or partition type is to your preferences.
    * If you want to use wifi - use `iwctl` before starting arch install script. Check this [video](https://www.youtube.com/watch?v=P_AJZwyoyyE) if you don't know how.
    * Unplug pendrive and reboot after successfull installation.

## Post installation tweaks
1. Install `yay` - an AUR helper with `pacman -S --needed git base-devel && cd ~ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd ~ && rm ./yay -r` chain of commands.
2. Add kernel parameters to hide basic logs and warnings. It's very unlikely but if someone looked at your screen and seen any warning - they could try abusing it in some way. Also it's just nicer to have clean startup screen. So - add `quiet` and `loglevel=3` to `/etc/kernel/cmdline` file.
    * Example content of **/etc/kernel/cmdline**:
    * ```cryptdevice=PARTUUID=XXXXXX-XXX-XX:root root=/dev/mapper/root rw rootfstype=ext4 quiet loglevel=3```
3. Release new **UKI** by typing `sudo mkinitcpio -P` command.
    * **Warning!** Some machines (mostly laptops) may receive warnings about potentially missing firmware. It's usually not a big deal but if you want to fix it - you'll have to manually find and install missing firmware. I've found [mkinitcpio-firmware](https://aur.archlinux.org/packages/mkinitcpio-firmware) to contain a lot of missing firmwares, it might be worth a try to install it on your machine too. After that, repeat first command to rebuild UKI.

## Secue boot
1. Install [sbctl](https://archlinux.org/packages/extra/x86_64/sbctl/) with `yay -S sbctl`.
2. Enter sudo for next commands and type `sbctl status` - you should see secure bot disabled and setup mode **enabled**. If you're not in setup mode - try again resetting secure bot keys and tpm cache in your bios settings.
3. Create & enroll new secure key with `sbctl create-keys && sbctl enroll-keys -m` commands.
    * You can use `sbctl status` to check new owner GUID.
4. Sign **UKI** by typing `sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi`
    * **Warning!** Exact file path may differ if you ignored archinstall and made own, custom installation or made some uncommon partitioning.
    * Sign any other file used by your systemd-boot. Type `sbctl verify` to display all files and sign them one by one by writing `sbctl sign -s <file>` command.
5. Check `sbctl status` - you should see secure bot enabled and setup mode automatically disabled. Now - restart your machine and enter bios to enable secure boot and you're be done with this part.
    * Some bios vendors may automatically detect new keys and automatically enable secure bot.