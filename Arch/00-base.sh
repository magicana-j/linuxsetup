#!/bin/sh

if [ -d log]; then
    mkdir log
fi

pkgs=(
    
)

printf "Installing Packages...\n"
for pkg in "${pkgs[@]}"; do
    sudo pacman -S --needed --noconfirm "$pkg" 2>&1 || tee -a "log/log-base_$(date +%Y%m%d-%H%M%S).txt
done


printf "\n%.0s" {1..2}
