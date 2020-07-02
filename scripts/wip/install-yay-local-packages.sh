#!/bin/bash


filename='../../.backup/arch-local-packages.txt'

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

clear
figlet Finished
exit 0




