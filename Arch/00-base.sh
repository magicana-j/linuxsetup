#!/bin/sh

if [ -d log]; then
    mkdir log
fi

pkgs=(
    bluez
    bluez-utils
    blueman
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

printf "Installing Packages...\n"
for pkg in "${pkgs[@]}"; do
    sudo pacman -S --needed --noconfirm "$pkg" 2>&1 || tee -a "log/log-base_$(date +%Y%m%d-%H%M%S).txt
done


printf "\n%.0s" {1..2}
