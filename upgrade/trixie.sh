#!/bin/bash

set -e

# Function to print a message
print_message() {
  echo " "
  echo "==========================================================================="
  echo "$1"
  echo "==========================================================================="
  echo " "
}

# Function to back up sources.list
backup_sources_list() {
  print_message "Backing up sources.list..."
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
  sudo cp /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.list.backup 2>/dev/null || true
}

# Function to restore sources.list
restore_sources_list() {
  print_message "Restoring original sources.list..."
  sudo cp /etc/apt/sources.list.backup /etc/apt/sources.list
  sudo cp /etc/apt/sources.list.d/*.list.backup /etc/apt/sources.list.d/*.list 2>/dev/null || true
  sudo apt update
}

# Function to update current system
update_system() {
  print_message "Updating the current system..."
  sudo apt update
  sudo apt upgrade -y
  sudo apt full-upgrade -y
  sudo apt autoremove --purge -y
  sudo apt clean
}

# Function to change sources from Bookworm to Trixie
update_sources_list() {
  print_message "Updating sources.list to Trixie..."
  sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
  sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list.d/*.list || true
}

# Function to upgrade to Debian 13
upgrade_to_trixie() {
  print_message "Upgrading to Debian 13 (Trixie)..."
  sudo apt update
  if ! sudo apt upgrade -y; then
    print_message "Upgrade failed, restoring original sources.list..."
    restore_sources_list
    exit 1
  fi
  sudo apt full-upgrade -y
  sudo apt autoremove --purge -y
  sudo apt clean
}

# Function to check and fix any broken packages
fix_broken_packages() {
  print_message "Checking for and fixing broken packages..."
  sudo apt --fix-broken install -y
}

# Function to remove backup files
cleanup_backups() {
  print_message "Cleaning up backup files..."
  sudo rm -f /etc/apt/sources.list.backup
  sudo rm -f /etc/apt/sources.list.d/*.list.backup 2>/dev/null || true
}

# Main script execution
main() {
  print_message "Starting the upgrade process from Debian 12 (Bookworm) to Debian 13 (Trixie)..."
  
  # Back up sources.list
  backup_sources_list
  
  # Update the current system
  update_system
  
  # Change sources from Bookworm to Trixie
  update_sources_list
  
  # Upgrade to Debian 13
  upgrade_to_trixie
  
  # Fix any broken packages
  fix_broken_packages
  
  print_message "Upgrade process completed successfully. Cleaning up backups..."
  
  # Remove backup files
  cleanup_backups
  
  print_message "Upgrade and cleanup completed successfully. A reboot is highly recommended."
}

main
