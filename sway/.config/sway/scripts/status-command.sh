# Icons
KB_ICON="   "
VOLUME_ACTIVE_ICON="    "
VOLUME_MUTED_ICON=""
BATTERY_FULL_ICON="󰁹"
BATTERY_DISCHARGE_ICON="󰂁"
BATTERY_CHARGE_ICON="󱐋"
BACKLIGHT_ICON=""
NET_LAN_ICON=""
NET_WIFI_ICON=""
NET_BRIDGE_ICON="󰘘"
NET_TUN_ICON="󱠽"
NET_DOWN_ICON=""
BLUETOOTH_ICON=""
BLUETOOTH_CONNECTED_ICON="<sup></sup>"
NOTIFICATIONS_ACTIVE_ICON=""
NOTIFICATIONS_MUTED_ICON=""

# Date
date_module=$(date +'%e  %a  %H:%M')

# Keyboard
keyboard_module="$KB_ICON"

keyboard_module_fnc() {
    keyboard_module="$keyboard_module$(swaymsg -t get_inputs \
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
        && echo "$VOLUME_MUTED_ICON" || echo "$VOLUME_ACTIVE_ICON$audio_module%")
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
        icon="$BATTERY_CHARGE_ICON"
    elif [[ $status = "Discharging" ]]; then
        icon="$BATTERY_DISCHARGE_ICON"
    else
        icon="$BATTERY_FULL_ICON"
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
        backlight_module="$BACKLIGHT_ICON  $percent%"
    fi
}
backlight_module_fnc

# Network
network_module="$NET_DOWN_ICON"

network_module_fnc() {
    default_iface=$(ip route 2>/dev/null | awk '/^default/ {print $5; exit}')

    if [[ -n "$default_iface" ]]; then
        if [[ -d "/sys/class/net/$default_iface/device" ]]; then
            if [[ $default_iface == wl* ]]; then
                network_module="$NET_WIFI_ICON"
            else
                network_module="$NET_LAN_ICON"
            fi
        elif [[ -d "/sys/class/net/$default_iface/bridge" ]]; then
            network_module="$NET_BRIDGE_ICON"
        elif [[ -e "/sys/class/net/$default_iface/tun_flags" ]]; then
            network_module="$NET_TUN_ICON"
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
            bluetooth_module="${BLUETOOTH_ICON}${BLUETOOTH_CONNECTED_ICON}"
        else
            bluetooth_module="$BLUETOOTH_ICON"
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
        notifications_module="$NOTIFICATIONS_ACTIVE_ICON"
    else
        if [ "$count" != "0" ]; then
            notifications_module="$NOTIFICATIONS_MUTED_ICON <sup>$count</sup>"
        else
            notifications_module="$NOTIFICATIONS_MUTED_ICON"
        fi
    fi
}
notifications_module_fnc

# Formatted final output with proper margin
# Margin... using spaces. Sorry not sorry :)
modules=()

[[ -n "$backlight_module" ]]     && modules+=("   $backlight_module")
[[ -n "$battery_module" ]]       && modules+=("   $battery_module")
[[ -n "$bluetooth_module" ]]     && modules+=("   $bluetooth_module")
[[ -n "$network_module" ]]       && modules+=("  $network_module")
[[ -n "$audio_module" ]]         && modules+=("  $audio_module")
[[ -n "$notifications_module" ]] && modules+=("   $notifications_module")
[[ -n "$keyboard_module" ]]      && modules+=("  $keyboard_module")
[[ -n "$date_module" ]]          && modules+=("    $date_module ")

echo "${modules[*]}"

