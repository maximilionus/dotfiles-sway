#!/bin/bash

POWER_TIMEOUT=10


swayidle \
    timeout $POWER_TIMEOUT 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' &

swaylock

kill %%
