#!/bin/bash

pkgs=(
	noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-emoji
    adobe-source-code-pro-fonts
    fcitx5-im
    fcitx5-configtool
    fcitx5-mozc
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

printf " Setting up fcitx5 ...\n"
cat << EOF >> ~/.xprofile
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
EOF

printf "\n%.0s" {1..2}
