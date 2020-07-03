#!/bin/bash

echo "Generating the lists of explicitly installed packages in ~/.backup"

pacman -Qqen > ../../.backup/arch-pacman-packages.txt || echo "pacman failed"
pacman -Qqem > ../../.backup/arch-local-packages.txt || echo "pacman failed"
gem list > ../../.backup/gem-packages.txt || echo "gem failed"
npm list -g --depth=0 > ../../.backup/npm-packages.txt || echo "npm failed"
pip list > ../../.backup/pip-packages.txt || echo "pip failed"
cargo --list | tail -n +2 | tr -d " " > ../../.backup/cargo-packages.txt || echo "cargo failed"
ghc-pkg list > ../../.backup/ghc-pkg-packages.txt || echo "ghc-pkg failed"
composer global show | cut -d ' ' -f1 > ../../.backup/composer-packages.txt || echo "composer failed"

git add -f .backup

exit 0