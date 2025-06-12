#!/bin/bash

swayidle \
    timeout 5 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &

swaylock -c 000000 -s fill -i ~/Pictures/wallpaper

kill %%
