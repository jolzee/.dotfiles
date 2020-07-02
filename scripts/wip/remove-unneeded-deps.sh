#!/bin/bash

echo "Use pacman to remove packages that were installed as dependencies and are no longer needed."

sudo pacman -Rs $(pacman -Qtdq)