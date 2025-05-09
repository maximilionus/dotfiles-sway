Personal configurations for Sway window manager and other components.


This configuration is intended to be used only on Arch Linux distribution.

To apply it, firstly install all the required packages. Note that this package
list **does not** contain many essential system components:
    # cat pkglist.txt | pacman -S -

After that, apply the configurations using gnu-stow:
    $ stow <dir>


Extended controls above vanilla Sway configuration:
    Mod key                      : Meta (Win)
    Floating mode switch         : $mod + f
    Floating focus switch        : Alt + Tab
    Full-screen mode switch      : $mod + Shift + f
    Set workspace layer (offset) : $mod + Alt + <0..9>
    Cancel object split          : $mod + c
