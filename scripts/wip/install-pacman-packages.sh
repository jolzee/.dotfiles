#!/bin/bash

echo "Install Arch packages using pacman from list arch-pacman-packages.txt"

sudo pacman -S --needed $(comm -12 <(pacman -Slq|sort) <(sort ../../.backup/arch-pacman-packages.txt) )