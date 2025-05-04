Personal configuration for sway window manager


This configuration is intended to be used only on Arch linux distribution, as
it heavily relies on it's package base.

To apply it, first install all the required packages:
    # cat pkglist.txt | pacman -S -
Note that this package list **does not** some essential system components.

After that, apply the configurations using gnu-stow:
    $ stow <dir>
