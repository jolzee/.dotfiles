# if we have a screen, we can try a colored screen
if [[ "$TERM" == "screen" ]]; then
    export TERM="screen-256color"
fi

# activate ls colors, (private if possible)
export ZSH_DIRCOLORS="$ZSH_CONFIG/dircolors-solarized/dircolors.256dark"
if [[ -a $ZSH_DIRCOLORS ]]; then
    if [[ "$TERM" == *256* ]]; then
        which dircolors > /dev/null && eval "`dircolors -b $ZSH_DIRCOLORS 2>/dev/null`"
    else
        # standard colors for non-256-color terms
        which dircolors > /dev/null && eval "`dircolors -b`"
    fi
else
    which dircolors > /dev/null && eval "`dircolors -b`"
fi

alias up=" nmcli con up id"
alias down=" nmcli con down id"

LSB_DISTRIBUTOR=`lsb_release -i -s`

# debian and ubuntu specific aliases
## autocomplete-able apt-xxx aliases
if [[ "$LSB_DISTRIBUTOR" == "Ubuntu" ]]; then
    alias acs='apt-cache show'
    alias agi='sudo apt-get install'
    alias ag='sudo apt-get'
    alias agu='sudo apt-get update'
    alias agug='sudo apt-get upgrade'
    alias aguu='agu && agug'
    alias agr='sudo apt-get uninstall'
    alias agp='sudo apt-get purge'
    alias aga='sudo apt-get autoremove'
    alias ctl='sudo service '
    alias feierabend='sudo shutdown -h now'
fi

# arch linux with systemd aliases
if [[ "$LSB_DISTRIBUTOR" == "Arch" ]]; then
    # statements
    alias ctl='sudo systemctl '
    alias feierabend='sudo systemctl start poweroff.target'
    alias start=" sudo systemctl start"
    alias stop=" sudo systemctl stop"
    alias status=" sudo systemctl status"
    alias restart=" sudo systemctl restart"
    alias reboot="sudo systemctl start reboot.target"
    # pacman aliases
    alias pac='sudo pacman -S'   # install
    alias pacu='sudo pacman -Syu'    # update, add 'a' to the list of letters to update AUR packages if you use yaourt
    alias pacr='sudo pacman -Rs'   # remove
    alias pacs='sudo pacman -Ss'      # search
    alias paci='sudo pacman -Si'      # info
    alias paclo='sudo pacman -Qdt'    # list orphans
    alias pacro='paclo && sudo pacman -Rns $(pacman -Qtdq)' # remove orphans
    alias pacc='sudo pacman -Scc'    # clean cache
    alias paclf='sudo pacman -Ql'   # list files
    # yay aliases
    alias yai='yay -S' # install package(s)
    alias yas='yay -Ss' # search packages
    alias yadel='sudo pacman -Rnscd --force' # remove package 
    alias yad='yay -Si' # description of the package
    # > If no arguments are provided 'yay -Syu' will be performed
    alias yau='yay -Syu'
    # remove package(s)
    alias yar='yay -Rns' # update all packages
    alias yac='yay -Yc'  # clean unwanted packages
fi

