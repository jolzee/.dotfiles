#!/bin/bash

echo "Install Arch packages using pacman from list arch-pacman-packages.txt"

#sed -r '/^#/d' ../../.backup/arch-pacman-packages.txt | sudo pacman --needed -S -

installable_packages=$(comm -12 <(pacman -Slq | sort) <(sort ../../.backup/arch-pacman-packages.txt))
pacman -S --needed $installable_packages

exit 0
