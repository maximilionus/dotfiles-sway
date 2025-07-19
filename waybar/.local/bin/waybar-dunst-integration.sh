#!/usr/bin/env bash

readonly ENABLED=''
readonly DISABLED=''

last_output=""

while true; do
    paused=$(dunstctl is-paused)
    count=$(dunstctl count waiting)
    if [ "$paused" == "false" ]; then
        class="enabled"
        text="$ENABLED"
    else
        class="disabled"
        if [ "$count" != "0" ]; then
            text="$DISABLED <sup>$count</sup>"
        else
            text="$DISABLED"
        fi
    fi

    output=$(printf '{"text": "%s", "class": "%s"}\n' "$text" "$class")

    if [ "$output" != "$last_output" ]; then
        echo "$output"
        last_output="$output"
    fi

    sleep 1
done
