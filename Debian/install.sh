#!/bin/sh

# パッケージのインストール処理を行う関数
install_packages() {
    # パッケージがインストールされているか確認
    if dpkg -l | grep -q -w "$1" &> /dev/null; then
        echo "$1 is already installed. Skipping."
    else
        echo "Installing $1 ..."
        ( sudo apt install -y "$1" 2>&1) >> $2 2>&1 &
        if dpkg -l | grep -q -w "$1" &> /dev/null; then
            echo "$1 is installed successfully."
        else
            echo "$1 is failed to be installed."
        fi
    fi
}
