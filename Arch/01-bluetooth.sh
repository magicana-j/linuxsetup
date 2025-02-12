#!/bin/bash

pkgs=(
    bluez
    bluez-utils
    blueman
)

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/main.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_bluetooth.log"

# Install
printf "Installing Packages...\n"
for pkg in "${pkgs[@]}"; do
    install_package "$pkg" "$LOG"
done

printf " Activating ${YELLOW}Bluetooth${RESET} Services...\n"
sudo systemctl enable --now bluetooth.service 2>&1 | tee -a "$LOG"

printf "\n%.0s" {1..2}
