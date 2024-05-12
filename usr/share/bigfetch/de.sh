#!/usr/bin/env bash

if [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    de="KDE Plasma"
    deVersion=$(pacman -Q | awk '/plasma-desktop/ {split($2, a, "-"); print a[1]}')
elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    de=Gnome
    deVersion=$(gnome-shell --version 2> /dev/null | awk '{print $3}') 2> /dev/null
elif [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
    de=Xfce
    deVersion=$(xfce4-session --version 2> /dev/null | grep -E 'xfce4-session [0-9]' | awk '{print $2}') 2> /dev/null
fi

echo $de $deVersion
