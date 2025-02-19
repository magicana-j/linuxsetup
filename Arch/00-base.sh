#!/usr/bin/bash

pkgs=(
    ffmpeg
    openh264
    vlc
    firefox
    go
    gparted
    pacman-contrib
    vim
    neovim
    nano
    less
    timeshift
    htop
    fastfetch
    wget
    curl
    zip
    unzip
    xarchiver
    xf86-input-synaptics
    bash-completion
    ufw
    gufw
    xdg-user-dirs-gtk
    reflector
    mousepad
    geany
    lm_sensors
    tmux
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


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_bluetooth.log"

# Install
printf "Installing Packages...\n"
for pkg in "${pkgs[@]}"; do
    install_package "$pkg" "$LOG"
done

source ./yay-setup.sh

printf "\n%.0s" {1..2}
