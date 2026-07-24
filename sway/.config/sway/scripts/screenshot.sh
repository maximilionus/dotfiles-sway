#!/usr/bin/env bash

set -e

SCREENSHOTS_PATH="$HOME/Pictures/Screenshots"

crop() {
    tmp_bg="/tmp/screenshot-freeze-$(date +%s).png"

    prepare

    grim \
        -l 0 \
        -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') \
        "$tmp_bg"
    imv -f $tmp_bg &
    sleep 0.01

    region=$(slurp || true)

    kill %%
    rm "$tmp_bg"

    [[ ! -n $region ]] && exit 1

    grim -g "$region" - | wl-copy
    notify-send --urgency low "Screenshot (Selection)" "Copied to clipboard"
}

fullscreen() {
    to_clipboard="$1"

    prepare

    if [[ "$to_clipboard" -ne 1 ]]; then
        img_path="$SCREENSHOTS_PATH/screenshot-$(date +%Y%m%d-%H%M%S).png"

        grim \
            -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') \
            "$img_path"
        notify-send --urgency low "Screenshot (Fullscreen)" "Saved to $img_path"
    else
        grim \
            -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') - \
            | wl-copy
        notify-send --urgency low "Screenshot (Fullscreen)" "Copied to clipboard"
    fi
}

prepare() {
    mkdir -p "$SCREENSHOTS_PATH"
}

case "$1" in
    crop-copy)
        crop
        ;;
    fullscreen-copy)
        fullscreen 1
        ;;
    *|fullscreen)
        fullscreen
        ;;
esac
