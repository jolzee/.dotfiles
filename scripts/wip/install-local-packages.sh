#!/bin/bash

echo "Install Arch local or AUR packages from arch-local-packages.txt"

pacaur -S --noedit --noconfirm --needed ../../.backup/arch-pacman-packages.txt