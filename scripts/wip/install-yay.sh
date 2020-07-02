sudo pacman --color --noconfirm -S git
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay --editmenu --nodiffmenu --save
yay
