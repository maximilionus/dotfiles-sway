#!/bin/bash

DISPLAY_TIMEOUT=10


swayidle \
    timeout $DISPLAY_TIMEOUT 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &

swaylock

kill %%

# Restart Waybar after waking up from suspend, as it appears to have corrupted
# output on some modules (kb language for example).
[[ $1 == "suspend" ]] && pkill -SIGUSR2 waybar
