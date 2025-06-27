Personal configurations for Sway window manager and other components.


This configuration is intended to be used only on Arch Linux distribution.

To use it, install all the required packages first:
    # cat pkglist.txt | pacman -S --needed -

Note: This package list contains only packages that are strictly required for
this desktop environment to work

After that, apply the configurations using gnu-stow:
    $ stow <dir>

Note: GNU-Stow is kinda terrible at dir manipulations, so be sure that basic
dirs like "~/.local/bin" and "~/.config/profile.d" already exist, so it doesn't
overlap them, or use the "--no-folding" flag on run. It's either I don't get
how it works, or it's just terrible by itself... I need to write my own
dotfiles manager huh.


EXTENDED CONTROLS
    Mod key                                  : Meta (Win)
    Floating mode switch                     : $mod + f
    Floating focus switch                    : Alt + Tab
    Kill focused window                      : $mod + q
    Kill (SIGKILL) focused window            : $mod + Shift + q
    Resize focused window left/down/up/right : $mod + y/u/i/o
    Full-screen mode switch                  : $mod + m
    Always-on-top window switch              : $mod + Shift + s
    Set workspace layer (offset)             : $mod + Alt + <0..9>
    Cancel object split                      : $mod + c
    Turn display power off                   : $mod + PgDown
    Turn display power on                    : $mod + PgUp
