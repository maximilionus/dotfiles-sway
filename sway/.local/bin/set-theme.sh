#!/bin/bash

set_gsettings_theme () {
    mode="$1"
    color_scheme="default"
    gtk_theme="Adwaita"

    if [[ $mode == "dark" ]]; then
        color_scheme="prefer-dark"
        gtk_theme="${gtk_theme}-dark"
    fi

    gsettings set org.gnome.desktop.interface color-scheme "$color_scheme"
    gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
}


case $1 in
    l*|0)
        set_gsettings_theme light
        ;;
    d*|1)
        set_gsettings_theme dark
        ;;
esac
