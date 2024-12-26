package main

import (
	"os"

	"github.com/amatsagu/dotfiles/logger"
	"github.com/amatsagu/dotfiles/pkg"
)

func main() {
	logger.Text("Updating system packages before attempting any changes...")
	pkg.UpdateSystem(false)

	if !pkg.TRIXIE {
		attemptTrixieUpgrade()
	}

	coreInstall()
	swayAndUtilInstall()
	themeInstall()
}

func coreInstall() {
	logger.Text("Proceeding with installation of core packages...")
	pkg.InstallPackages(pkg.CORE_PACKAGES)

	if pkg.SUPPORTS_BLUETOOTH {
		pkg.RemovePackages([]string{"pulseaudio-module-bluetooth"})

		logger.SubText(" | Enabling bluetooth service...")
		res, err := pkg.RunCommand("sudo", "systemctl", "enable", "bluetooth")
		if err != nil {
			logger.Warn(" | Failed to enable bluetooth service(s):\n" + res)
		}
	}

	logger.SubText(" | Enabling pipewire audio services...")
	res, err := pkg.RunCommand("systemctl", "--user", "--now", "enable", "pipewire", "pipewire-pulse")
	if err != nil {
		logger.Warn(" | Failed to enable pipewire services:\n" + res)
	}

	logger.SubText(" | Reloading user system daemons...")
	res, err = pkg.RunCommand("systemctl", "--user", "daemon-reload")
	if err != nil {
		logger.Warn(" | Failed to reload user daemons:\n" + res)
	}

	logger.Success("Installed all basic packages. From this point, you should see working network, bluetooth, audio, etc.")
}

func attemptTrixieUpgrade() {
	logger.Warn("Attempting to upgrade Debian 12 (Bookworm) into Debian 13 (Trixie)...")

	logger.SubText(" | Backing up current list of repositories...")
	res, err := pkg.RunCommand("sudo", "cp", "/etc/apt/sources.list", "/etc/apt/sources.list.backup")
	if err != nil {
		logger.Error(" | Failed to create backup:\n" + res)
		os.Exit(1)
	}

	res, err = pkg.RunCommand("sudo", "cp", "/etc/apt/sources.list.d/*.list", "/etc/apt/sources.list.d/*.list.backup")
	if err != nil {
		logger.Error(" | Failed to create backup:\n" + res)
		os.Exit(1)
	}

	logger.SubText(" | Updating registry sources from Bookworm to Trixie...")
	res, err = pkg.RunCommand("sudo", "sed", "-i", "'s/bookworm/trixie/g'", "/etc/apt/sources.list")
	if err != nil {
		logger.Error(" | Failed to rewrite sources:\n" + res)
		os.Exit(1)
	}

	res, err = pkg.RunCommand("sudo", "sed", "-i", "'s/bookworm/trixie/g'", "/etc/apt/sources.list.d/*.list")
	if err != nil {
		logger.Error(" | Failed to rewrite sources:\n" + res)
		os.Exit(1)
	}

	logger.SubText(" | Updating system & packages...")
	pkg.UpdateSystem(true)

	logger.Success("Successfully upgraded to Debian 13, Trixie. It is highly recommended to make full system restart after finish.")
}

func swayAndUtilInstall() {
	logger.Text("Proceeding with installation of main sway packages & util apps that creates desktop experience...")
	pkg.InstallPackages(pkg.SWAY_PACKAGES)
	logger.Success("Installed all main sway packages & util apps.")
}

func themeInstall() {
	logger.Text("Proceeding with installation of themes (icons, cursors, fonts and gtk styles)...")
	pkg.InstallPackages(pkg.THEME_PACKAGES)

	logger.Text("Applying changes to cursors... (can take a while)")
	res, err := pkg.RunCommand("bash", "./script/cursor.sh")
	if err != nil {
		logger.Error(" | Failed to execute ./script/cursor.sh script:\n" + res)
		os.Exit(1)
	}

	logger.Text("Applying changes to GTK themes... (can take a while)")
	res, err = pkg.RunCommand("bash", "./script/gtk-theme.sh")
	if err != nil {
		logger.Error(" | Failed to execute ./script/gtk-theme.sh script:\n" + res)
		os.Exit(1)
	}

	logger.Text("Applying changes to folder icons... (can take a while)")
	res, err = pkg.RunCommand("bash", "./script/papirus-folders.sh")
	if err != nil {
		logger.Error(" | Failed to execute ./script/papirus-folders.sh script:\n" + res)
		os.Exit(1)
	}

	logger.Text("Applying preferences...")
	res, err = pkg.RunCommand("bash", "./script/gsettings.sh")
	if err != nil {
		logger.Error(" | Failed to execute ./script/gsettings.sh script:\n" + res)
		os.Exit(1)
	}

	logger.Text("Cloning configs/dotfiles...")
	res, err = pkg.RunCommand("bash", "./script/clone-configs.sh")
	if err != nil {
		logger.Error(" | Failed to execute ./script/clone-configs.sh script:\n" + res)
		os.Exit(1)
	}

	logger.Success("Successfully installed & applied all style preferences/configs.")
}
