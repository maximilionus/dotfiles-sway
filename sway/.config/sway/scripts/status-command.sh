#!/bin/bash

SPLITTER="<span foreground=\"gray\">|</span>"

KB_PREFIX="<span weight=\"bold\">LANG</span> "
VOLUME_ACTIVE_PREFIX="<span weight=\"bold\">VOL</span> "
VOLUME_MUTED_PREFIX="${VOLUME_ACTIVE_PREFIX}Muted"
BATTERY_FULL_PREFIX="<span weight=\"bold\">BAT</span> "
BATTERY_DISCHARGE_PREFIX="$BATTERY_FULL_PREFIX"
BATTERY_CHARGE_PREFIX="$BATTERY_FULL_PREFIX"
BACKLIGHT_PREFIX="<span weight=\"bold\">B</span> "
NET_PREFIX="<span weight=\"bold\">NET</span>"
NET_LAN_PREFIX="$NET_PREFIX Eth"
NET_WIFI_PREFIX="$NET_PREFIX WiFi"
NET_BRIDGE_PREFIX="$NET_PREFIX Bridge"
NET_TUN_PREFIX="$NET_PREFIX Tunnel"
NET_DOWN_PREFIX="$NET_PREFIX Offline"
BLUETOOTH_PREFIX="<span weight=\"bold\">BT</span>"
BLUETOOTH_CONNECTED_PREFIX="${BLUETOOTH_PREFIX} Con"
NOTIFICATIONS_ACTIVE_PREFIX=""
NOTIFICATIONS_MUTED_PREFIX="<span weight=\"bold\">NOTIF</span> Silent"

# Date
date_module=$(date +'%e  %a  %H:%M')

# Keyboard
keyboard_module="$KB_PREFIX"

keyboard_module_fnc() {
    keyboard_module="${keyboard_module}$(swaymsg -t get_inputs \
        | jq -r '.[] | select(.type=="keyboard") | .xkb_active_layout_name' \
        | head -n1 \
        | cut -d' ' -f1 \
        | cut -c1-2)"
}
keyboard_module_fnc

# Audio
audio_module=""

audio_module_fnc() {
    audio_pipewire=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    audio_module=$(echo "$audio_pipewire" | awk '{print $2*100}')
    audio_module=$(echo "$audio_pipewire" | grep -q MUTED \
        && echo "$VOLUME_MUTED_PREFIX" || echo "$VOLUME_ACTIVE_PREFIX$audio_module%")
}
audio_module_fnc

# Battery
battery_module=""

battery_module_fnc() {
    battery_status=$(ls /sys/class/power_supply/ | grep BAT | head -n1)

    if [[ -z $battery_status ]]; then
        return 0
    fi

    capacity=$(cat /sys/class/power_supply/$battery_status/capacity)
    status=$(cat /sys/class/power_supply/$battery_status/status)

    if [[ $status = "Charging" ]]; then
        icon="$BATTERY_CHARGE_PREFIX"
    elif [[ $status = "Discharging" ]]; then
        icon="$BATTERY_DISCHARGE_PREFIX"
    else
        icon="$BATTERY_FULL_PREFIX"
    fi

    battery_module="$icon $capacity%"
}
battery_module_fnc

# Screen backlight
backlight_module=""

backlight_module_fnc() {
    backlight_dir="/sys/class/backlight"
    device=$(ls "$backlight_dir" 2>/dev/null | head -n1)

    if [[ -n "$device" ]]; then
        max_brightness=$(cat "$backlight_dir/$device/max_brightness")
        cur_brightness=$(cat "$backlight_dir/$device/brightness")
        percent=$(( cur_brightness * 100 / max_brightness ))
        backlight_module="$BACKLIGHT_PREFIX  $percent%"
    fi
}
backlight_module_fnc

# Network
network_module="$NET_DOWN_PREFIX"

network_module_fnc() {
    default_iface=$(ip route 2>/dev/null | awk '/^default/ {print $5; exit}')

    if [[ -n "$default_iface" ]]; then
        if [[ -d "/sys/class/net/$default_iface/device" ]]; then
            if [[ $default_iface == wl* ]]; then
                network_module="$NET_WIFI_PREFIX"
            else
                network_module="$NET_LAN_PREFIX"
            fi
        elif [[ -d "/sys/class/net/$default_iface/bridge" ]]; then
            network_module="$NET_BRIDGE_PREFIX"
        elif [[ -e "/sys/class/net/$default_iface/tun_flags" ]]; then
            network_module="$NET_TUN_PREFIX"
        else
            network_module="Network (Unknown type)"
        fi
    fi
}
network_module_fnc

# Bluetooth
bluetooth_module=""

bluetooth_module_fnc() {
    if ! systemctl is-active --quiet bluetooth.service; then
        return 0
    fi

    bluetooth_power=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
    if [ "$bluetooth_power" = "yes" ]; then
        connected=$(bluetoothctl info | grep "Connected: yes")

        if [ -n "$connected" ]; then
            bluetooth_module="${BLUETOOTH_PREFIX}${BLUETOOTH_CONNECTED_PREFIX}"
        else
            bluetooth_module="$BLUETOOTH_PREFIX"
        fi
    fi
}
bluetooth_module_fnc

# Notifications
notifications_module=""

notifications_module_fnc() {
    if ! pidof dunst > /dev/null; then
        return 0;
    fi

    paused=$(dunstctl is-paused)
    count=$(dunstctl count waiting)

    if [ "$paused" == "false" ]; then
        notifications_module="$NOTIFICATIONS_ACTIVE_PREFIX"
    else
        if [ "$count" != "0" ]; then
            notifications_module="$NOTIFICATIONS_MUTED_PREFIX <sup>$count</sup>"
        else
            notifications_module="$NOTIFICATIONS_MUTED_PREFIX"
        fi
    fi
}
notifications_module_fnc

# Formatted final output with proper margin
# Margin... using spaces. Sorry not sorry :)
modules=()

[[ -n "$backlight_module" ]]     && modules+=("  $SPLITTER  $backlight_module")
[[ -n "$battery_module" ]]       && modules+=("  $SPLITTER  $battery_module")
[[ -n "$bluetooth_module" ]]     && modules+=("  $SPLITTER  $bluetooth_module")
[[ -n "$network_module" ]]       && modules+=("  $SPLITTER  $network_module")
[[ -n "$audio_module" ]]         && modules+=("  $SPLITTER  $audio_module")
[[ -n "$notifications_module" ]] && modules+=("  $SPLITTER  $notifications_module")
[[ -n "$keyboard_module" ]]      && modules+=("  $SPLITTER  $keyboard_module")
[[ -n "$date_module" ]]          && modules+=("  $SPLITTER  $date_module")

echo "${modules[*]}   $SPLITTER  "
