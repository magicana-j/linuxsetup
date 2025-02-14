#!/bin/sh
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
sudo reflector --country Japan --protocol https --age 24 --sort rate --save /etc/pacman.d/mirrorlist
