#!/usr/bin/env bash

TIMEOUT="300" # Seconds until locked
LOCKER="$1"

SWAY_STATE="${XDG_RUNTIME_DIR:-/tmp/$USER}/sway"
PID_FILE="$SWAY_STATE/swayidle.pid"

[[ ! -d "$SWAY_STATE" ]] && mkdir -p "$SWAY_STATE"

swayidle -w \
    timeout "$TIMEOUT" "sh $LOCKER" \
    before-sleep "sh $LOCKER" &

echo $! > "$PID_FILE"
