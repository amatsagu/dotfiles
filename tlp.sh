sudo systemctl enable --now tlp.service
sudo systemctl enable --now tlp-pd.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
