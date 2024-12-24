package pkg

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/amatsagu/dotfiles/logger"
)

func RunCommand(args ...string) (string, error) {
	cmdCtx := exec.Command(args[0], args[1:]...)

	res, err := cmdCtx.CombinedOutput()
	if err != nil {
		return string(res), err
	}

	return string(res), nil
}

func InstallPackages(pkgs []string) {
	size := len(pkgs)
	for itx, value := range pkgs {
		logger.SubText(fmt.Sprintf(" | Installing %s... (%d/%d)", value, itx+1, size))
		res, err := RunCommand("sudo", "apt-get", "install", value, "-y")
		if err != nil {
			logger.Error("Failed at installation of " + value + " package:\n" + res)
			os.Exit(1)
		}
	}

}

func RemovePackages(pkgs []string) {
	size := len(pkgs)
	for itx, value := range pkgs {
		logger.SubText(fmt.Sprintf(" | Removing %s... (%d/%d)", value, itx+1, size))
		res, err := RunCommand("sudo", "apt-get", "purge", value, "-y")
		if err != nil {
			logger.Warn(" | Failed at deletion of " + value + " package:\n" + res)
		}
	}

}

func UpdateSystem(distroUpgrade bool) {
	res, err := RunCommand("sudo", "apt-get", "update", "-y")
	if err != nil {
		logger.Error(" | Found problem while trying to update repository packages:\n" + res)
		os.Exit(1)
	}

	res, err = RunCommand("sudo", "apt-get", "upgrade", "-y")
	if err != nil {
		logger.Error(" | Found problem while trying to upgrade system packages:\n" + res)
		os.Exit(1)
	}

	if distroUpgrade {
		res, err = RunCommand("sudo", "apt-get", "full-upgrade", "-y")
		if err != nil {
			logger.Error(" | Failed to fully upgrade distro (& system packages):\n" + res)
			os.Exit(1)
		}
	}

	res, err = RunCommand("sudo", "apt-get", "autoremove", "--purge", "-y")
	if err != nil {
		logger.Error(" | Found problem while trying to purge orphaned/no longer needed packages:\n" + res)
		os.Exit(1)
	}

	res, err = RunCommand("sudo", "apt-get", "clean")
	if err != nil {
		logger.Error(" | Found problem while trying to clean packages cache:\n" + res)
		os.Exit(1)
	}

	res, err = RunCommand("sudo", "apt-get", "install", "--fix-broken", "-y")
	if err != nil {
		logger.Warn(" | Failed to repair potentially damaged packages after update:\n" + res)
	}
}
