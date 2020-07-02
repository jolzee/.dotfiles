#!/bin/bash

echo "Install Arch packages using pacman from list arch-pacman-packages.txt"

sed -r '/^#/d' ../../.backup/arch-pacman-packages.txt | sudo pacman -S --needed -

exit 0
