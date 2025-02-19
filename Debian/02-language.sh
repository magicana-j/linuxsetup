#!/bin/sh

pkg_list=(
    fonts-noto-cjk
    fcitx5-mozc
    im-config
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

echo 'Setting up input method ...'
im-config -n fcitx5
wait 1
echo "Installation is completed! Log is saved in $(LOG_FILE)."


