#!/bin/bash

COMMAND="$1"
COMMAND_2="$2"
SWAY_STATE="$HOME/.local/state/sway"
LAYER_FILE="$SWAY_STATE/workspace_layer"

get_layer () {
    cat "$LAYER_FILE" 2>/dev/null || echo ""
}

case "$COMMAND" in
    get-layer)
        get_layer
        ;;
    set-layer)
        notify="Workspace layer"
        [[ ! -d $SWAY_STATE ]] && mkdir -p "$SWAY_STATE"
        if [[ $COMMAND_2 == 0 ]]; then
            COMMAND_2=""
            notify="$notify unset"
        else
            notify="$notify set to $COMMAND_2"
        fi
        echo "$COMMAND_2" > "$LAYER_FILE"
        notify-send "$notify"
        ;;
    set)
        swaymsg workspace number "$(get_layer)$COMMAND_2"
        ;;
    *)
        echo "Unknown command"
        ;;
esac
