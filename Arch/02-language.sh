#!/bin/sh

if [ -d log]; then
    mkdir log
fi

pkgs=(
    noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-emoji
    adobe-source-code-pro-fonts
    fcitx5-im
    fcitx5-configtool
    fcitx5-mozc
)

printf "Installing Packages...\n"
for pkg in "${pkgs[@]}"; do
    sudo pacman -S --needed --noconfirm "$pkg" 2>&1 || tee -a "log/log-language_$(date +%Y%m%d-%H%M%S).txt
done

printf " Setting up fcitx5 ...\n"
cat << EOF >> ~/.xprofile
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
EOF

printf "\n%.0s" {1..2}
