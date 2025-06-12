#!/bin/bash

POWER_TIMEOUT=10


swayidle \
    timeout $POWER_TIMEOUT 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &

swaylock -c 000000 -s fill -i ~/Pictures/wallpaper

kill %%
