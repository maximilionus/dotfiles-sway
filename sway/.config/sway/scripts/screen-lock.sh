#!/usr/bin/env bash

DISPLAY_TIMEOUT=10


swayidle \
    timeout $DISPLAY_TIMEOUT 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &

swaylock

kill %%
