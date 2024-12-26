package pkg

import (
	"os"
	"strings"

	"github.com/amatsagu/dotfiles/logger"
)

var CORE_PACKAGES = []string{
	"zip",
	"curl",
	"wget",
	"apt-transport-https",
	"network-manager",
	"rfkill",
	"gpg",
	"p7zip-full",
	"git",
	"webp",
	"nano",

	"pipewire",
	"pipewire-pulse",
	"pipewire-bin",
	"pipewire-alsa",
	"pipewire-jack",
	"pipewire-audio-client-libraries",
	"pipewire-audio",
	"wireplumber",
	"pavucontrol",
	"ffmpeg",
	"libpipewire-0.3-0t64",
	"gstreamer1.0-pipewire",
	"gstreamer1.0-pulseaudio",
	"gstreamer1.0-plugins-good",
	"gstreamer1.0-plugins-bad",
	"gstreamer1.0-plugins-base",
}

var SUPPORTS_BLUETOOTH bool
var SUPPORTED_CPU bool
var TRIXIE bool

func init() {
	logger.Text("Scanning for host specs...")

	cr, err := RunCommand("lscpu")
	if err != nil {
		logger.Error("Failed at detection of CPU:\n" + cr)
		os.Exit(1)
	}

	if strings.Contains(cr, "GenuineIntel") {
		SUPPORTED_CPU = true
		CORE_PACKAGES = append(CORE_PACKAGES, "intel-microcode")
		logger.Success("@ Successfully detected Intel based CPU!")
	}

	if strings.Contains(cr, "AuthenticAMD") {
		SUPPORTED_CPU = true
		CORE_PACKAGES = append(CORE_PACKAGES, "amd64-microcode")
		logger.Success("@ Successfully detected AMD based CPU!")
	}

	if !SUPPORTED_CPU {
		logger.Warn("@ Failed to detect CPU vendor! This installation may end poorly as it may not work with your CPU.")
	}

	if _, err := os.Stat("/sys/class/backlight"); err == nil {
		CORE_PACKAGES = append(CORE_PACKAGES, "brightnessctl")
		logger.Success("@ Successfully detected hardware for screen brightness control!")
	}

	if _, err := os.Stat("/sys/class/bluetooth"); err == nil {
		SUPPORTS_BLUETOOTH = true
		CORE_PACKAGES = append(CORE_PACKAGES, "blueman", "bluez", "libspa-0.2-bluetooth")
		logger.Success("@ Successfully detected hardware for bluetooth!")
	}

	cr, err = RunCommand("cat", "/etc/os-release")
	if err != nil {
		logger.Error("Failed at detection of current disto release:\n" + cr)
		os.Exit(1)
	}

	if !strings.Contains(cr, "ID=debian") {
		logger.Error("This linux distribution doesn't appear to be Debian. Exiting!")
		os.Exit(1)
	}

	if strings.Contains(cr, "VERSION_CODENAME=trixie") {
		TRIXIE = true
		logger.Success("@ Successfully detected Debian 13, Trixie - no upgrade required.")
	}

	logger.Text("Finished initial scanning. Updated core packages.")
}
