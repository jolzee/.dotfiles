#!/bin/bash
# A menu driven shell script sample template from mt 5
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'



# function to display menus
show_menus() {
  clear
  echo "----------------------------------------"
  echo -e "   ${RED} M A I N - M E N U ${STD}"
  echo "----------------------------------------"
  echo "1. Backup Packages"
  echo "2. Install Pacman Packages"
  echo "3. Dot Files Init"
  echo "4. Install Yay"
  echo "5. Install AUR Packages"
  echo "6. Rank AUR Mirrors for Region (requires root)"
  echo "7. Cylon Maintenance"
  echo "q. Exit"
  read_options
}

backupPackages() {
  clear
  echo -n -e "Running Backup Packages.."

  pacman -Qqent > .backup/arch-pacman-packages.txt || echo "pacman failed"
  pacman -Qqem > .backup/arch-local-packages.txt || echo "pacman failed"
  #gem list > .backup/gem-packages.txt || echo "gem failed"
  #npm list -g --depth=0 > .backup/npm-packages.txt || echo "npm failed"
  #pip list > .backup/pip-packages.txt || echo "pip failed"
  #cargo --list | tail -n +2 | tr -d " " > .backup/cargo-packages.txt || echo "cargo failed"
  #ghc-pkg list > .backup/ghc-pkg-packages.txt || echo "ghc-pkg failed"
  #composer global show | cut -d ' ' -f1 > .backup/composer-packages.txt || echo "composer failed"
  waitForKeyPress
  show_menus
}

installPacmanPackages() {
  clear
  echo "Install Arch packages using pacman from list arch-pacman-packages.txt"
  installable_packages=$(comm -12 <(pacman -Slq | sort) <(sort .backup/arch-pacman-packages.txt))
  sudo pacman -S --needed $installable_packages
  waitForKeyPress
  show_menus
}

installYay() {
  clear
  echo "Installing Yay"
  cwd=$(pwd)
  sudo pacman --color --noconfirm -S git
  cd /tmp
  sudo rm -rf yay
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  yay --editmenu --nodiffmenu --save
  yay
  cd cwd
  waitForKeyPress
  show_menus
}

installAURPackages() {
  clear
  echo ""
  filename='.backup/arch-local-packages.txt'

  iterlines() {
      (( $# < 2 )) && { echo "Usage: iterlines <File> <Callback>"; return; }
      local File=$1
      local Func=$2
      n=$(cat "$File" | wc -l)
      for (( i=1; i<=n; i++ )); do
          "$Func" "$(sed "${i}q;d" "$File")"
      done
  }

  installpackage() {
      clear
      figlet -f digital $1
      echo ""
      printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
      echo ""
      yay --needed --nodiffmenu --answerdiff=None --answerclean NotInstalled --noeditmenu -S $1
  }

  iterlines $filename installpackage

  # register and start espanso
  espanso register
  espanso start
  waitForKeyPress
  show_menus
}

waitForKeyPress() {
  echo ""
  read -p "Press any key to continue... " -n1 -s
}

dotFilesInit() {
  clear
  echo "Sym-linking all dot files.."
  set -e
  CONFIG="install.conf.yaml"
  DOTBOT_DIR="dotbot"

  DOTBOT_BIN="bin/dotbot"
  BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  cd "${BASEDIR}"
  git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
  git submodule update --init --recursive "${DOTBOT_DIR}"

  "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

  ### Check if a directory does not exist ###
  if [ ! -e ~/.zinit ]; then
    mkdir ~/.zinit
    git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
  fi

  chsh -s /bin/zsh

  waitForKeyPress
  show_menus
}

cylonMaintenance() {
  clear
  echo "Cylon Maintenance .."
  cylon
  waitForKeyPress
  show_menus
}

updateAurMirrorList() {
  clear
  echo "Updating AUR mirror list based on region"
  countries=(AT AU BE BG BR BY CA CH CL CN CO CZ DE DK EE ES FI FR GB GR HU IE IL IN IT JP KR KZ LK LU LV MK NC NL NO NZ PL PT RO RS RU SE SG SK TR TW UA US UZ VN ZA)
  country=""
  [ "$1" ] && country="$1"

  # Usage display if incorrect number of parameters given
  if [ $# -gt 1 -o "$1" = -h -o "$1" = --help ]; then
    echo "${0##*/} [*country code] - download pacman ranked mirrorlist"
    echo " "${countries[@]}"" | fmt -c -w 80
    exit 1; fi


  # Run as specific user
  # sudo -u $SUDO_USER <your command>
  
  # Root user access test
  if [ $EUID != 0 ]; then
    echo "Root user access required"; exit 1; fi

  # Select country from list
  if ! [ "$country" ]; then
    PS3="Select country: "
    select country in "${countries[@]}"; do
      test -n "$country" && break
      echo "Select 1, or 2..."
    done; fi

  # Test if $country is in $countries array
  if ! [[ " ${countries[*]} " == *" $country "* ]]; then
    echo "Invalid country code."
    exit 1; fi

  # Download
  url="https://www.archlinux.org/mirrorlist/?country=${country}&protocol=http&ip_version=4&use_mirror_status=on"
  tmp_ml=$(mktemp --suffix=-mirrorlist)  # temporary mirrorlist
  if curl -s "$url" -o "$tmp_ml"; then
    if ! grep "^## Arch Linux repository mirrorlist" "$tmp_ml" > /dev/null; then
      echo "Error: Download invalid"
      exit 1
    fi
  else
    echo "Error: Download failed"
    exit 1
  fi

  # Edit
  sed -i 's/^#Server/Server/g' "$tmp_ml"

  # View
  while true; do
    read -p "View the downloaded mirrorlist? (y/n): " yn
    case $yn in
      [Yy] )  if hash vim 2>&- ; then # use vim if available
                editor=vim
                editop=$(printf '%s' +"set syn=sh");
              else
                editor=${EDITOR}; fi
              "$editor" "$editop" "$tmp_ml"
              break 2 ;;
      [Nn] )  break 2 ;;
      [*]  )  true
    esac
  done

  # Backup
  bck_ml () {
  if [ -f /etc/pacman.d/mirrorlist ]; then
    mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist_$(date +%Y%m%d%H%M)
  else
    echo "Warning: no /etc/pacman.d/mirrorlist"
  fi ; }

  # Install
  while true; do
    read -p "Install new mirrorlist and backup previous? (y/n): " yn
    case $yn in
      [Yy] )  bck_ml
              install -Dm644 "$tmp_ml" /etc/pacman.d/mirrorlist
              break 2 ;;
      [Nn] )  break 2 ;;
      [*]  )  true
    esac
  done
  waitForKeyPress
  show_menus
}


# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
  local choice
  echo " "
  read -p "Enter choice: " choice
  case $choice in
    1)  backupPackages ;;
    2)  installPacmanPackages ;;
    3)  dotFilesInit ;;
    4)  installYay ;;
    5)  installAURPackages ;;
    6)  updateAurMirrorList ;;
    7)  cylonMaintenance ;;
    q)  clear && exit 0;;
    *) echo -e "${RED}Can not match with any selected${STD}" && sleep 1
  esac
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
#[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"
show_menus
