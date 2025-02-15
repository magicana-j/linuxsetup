#!/usr/bin/bash

pkgs=(
	podman
    podman-compose
    virtualbox-host-modules-arch
    virtualbox
    linux-headers
)

set -e

ISAUR=$(command -v yay || command -v paru)

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

install_package_pacman() {
    # Check if package is already installed
    if pacman -Q "$1" &>/dev/null ; then
        echo -e "$1 is already installed. Skipping..."
    else
        # Run pacman and redirect all output to a log file
        (
            stdbuf -oL sudo pacman -S --noconfirm "$1" 2>&1
        ) >> "$LOG" 2>&1 &
        
        # Double check if package is installed
        if pacman -Q "$1" &>/dev/null ; then
            echo -e "$1 has been successfully installed!"
        else
            echo -e "\n$1 failed to install. Please check the $LOG. You may need to install manually."
        fi
    fi
}

install_package() {
    if $ISAUR -Q "$1" &>> /dev/null ; then
        echo -e "$1 is already installed. Skipping..."
    else
        (
            stdbuf -oL $ISAUR -S --noconfirm "$1" 2>&1
        ) >> "$LOG" 2>&1 &
        PID=$!
        show_progress $PID "$1"  

        # Double check if package is installed
        if $ISAUR -Q "$1" &>> /dev/null ; then
            echo -e "$1 has been successfully installed!"
        else
            # Something is missing, exiting to review log
            echo -e "\n$1 failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
        fi
    fi
}

# Function for removing packages
uninstall_package() {
    local pkg="$1"

    # Checking if package is installed
    if pacman -Qi "$pkg" &>/dev/null; then
        echo -e "Removing $pkg ..."
        sudo pacman -R --noconfirm "$pkg" 2>&1 | tee -a "$LOG" | grep -v "error: target not found"

        if ! pacman -Qi "$pkg" &>/dev/null; then
            echo -e "$pkg removed."
        else
            echo -e "$pkg Removal failed. No actions required."
            return 1
        fi
    else
        echo -e "$pkg not installed, skipping."
    fi
    
    return 0
}


# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_bluetooth.log"

# Install
printf "Installing Packages...\n"
for pkg in "${pkgs[@]}"; do
    install_package "$pkg" "$LOG"
done

printf "\n%.0s" {1..2}
