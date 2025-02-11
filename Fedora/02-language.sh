#!/bin/sh

pkg_list=(
    fcitx5-mozc
    fcitx5-autostart
)

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_DIR="$SCRIPT_DIR/.."

if [ ! -d $(PARENT_DIR)/log ]; then
    mkdir $(PARENT_DIR)/log
fi

source "$(SCRIPT_DIR)/install.sh"

LOG_FILE="$(PARENT_DIR)/log/installation-_$(date +%Y%m%d-%H%M%S).txt"

for pkg in "${pkg_list}"; do
    install_packages "$pkg" "$LOG_FILE"
done

echo "Installation is completed! Log is saved in $(LOG_FILE)."

echo 'Setting up input method ...' && wait 1

cat << EOF >> ~/.xprofile
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
EOF

echo '*** $HOME/.xprofile has been created.'
