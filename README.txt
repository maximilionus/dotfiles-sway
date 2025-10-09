Personal configuration for Sway Window Manager and other components.

USAGE
    This configuration is intended to be used on Arch Linux.

    To apply it, firstly install all the required packages:
        # cat pkglist.txt | pacman -S --needed -

    After that, apply the configurations using GNU Stow:
        $ stow <dir>

NOTES
    These configurations are very heavily reliant on the main dotfiles
    repository and will not work properly if the user shell is not Zsh and
    don't have the zsh dotfiles already installed.

    GNU Stow is kinda strange at dir manipulations, so be sure that basic dirs
    like "~/.local/bin" and "~/.config/profile.d" already exist before running
    the stow command, so it doesn't symlink them, or use the "--no-folding"
    flag on run. It's either I don't get how it works, or it's just how it
    works by design... I need to write my own dotfiles manager huh:

        $ mkdir -p ~/.local/bin ~/.config/profile.d

    You can also add modular configurations to Sway by putting the .conf files
    in "~/.config/sway/config.d/".


EXTENDED CONTROLS
    Mod key (mod)                            - Meta (Win)
    Execute                                  - mod + Tab
    Exit window manager                      - mod + Shift + Escape
    Screen lock                              - mod + Escape
    Split mode                               - mod + e
    Tabbed mode                              - mod + w
    Stacking (Vertical tabs) mode            - mod + Shift + w
    Floating mode switch                     - mod + f
    Floating focus switch                    - Alt + Tab
    Kill focused window                      - mod + q
    Kill (SIGKILL) focused window            - mod + Shift + q
    Resize focused window left/down/up/right - mod (+ Shift) + y/u/i/o
    Full-screen mode switch                  - mod + m
    Always-on-top mode                       - mod + s
    Set workspace layer (offset)             - mod + Alt + <0..9>
    Object horizontal split                  - mod + g
    Object vertical split                    - mod + v
    Cancel object split                      - mod + c
    Screenshot (Selection to clibboard)      - PrntScr
    Screenshot (Active screen to file)       - Shift + PrntScr
    Turn display power off                   - mod + PgDown
    Turn display power on                    - mod + PgUp
