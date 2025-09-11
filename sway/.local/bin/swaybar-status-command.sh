# Icons
KB_ICON="   "
VOLUME_ACTIVE_ICON="    "
VOLUME_MUTED_ICON=""
NET_LAN_ICON="󰌗"
NET_WIFI_ICON="󰖩"
NET_DOWN_ICON="󰀝"
BLUETOOTH_ICON=""
BLUETOOTH_CONNECTED_ICON="<sup></sup>"
NOTIFICATIONS_ACTIVE_ICON=""
NOTIFICATIONS_MUTED_ICON=""

# Date
date_module=$(date +'%e  %a  %H:%M')

# Keyboard
keyboard_module=" $KB_ICON$(swaymsg -t get_inputs \
    | jq -r '.[] | select(.type=="keyboard") | .xkb_active_layout_name' \
    | head -n1 \
    | cut -d' ' -f1 \
    | cut -c1-2)"

# Audio
audio_pipewire=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
audio_module=$(echo "$audio_pipewire" | awk '{print $2*100}')
audio_module=$(echo "$audio_pipewire" | grep -q MUTED \
    && echo "$VOLUME_MUTED_ICON" || echo "$VOLUME_ACTIVE_ICON$audio_module%")

# Battery
battery_module=""
battery_status=$(ls /sys/class/power_supply/ | grep BAT | head -n1)

if [[ ! -z $battery_status ]]; then
    capacity=$(cat /sys/class/power_supply/$battery_status/capacity)
    status=$(cat /sys/class/power_supply/$battery_status/status)

    if [[ $status = "Charging" ]]; then
        icon="󱐋"
    elif [[ $status = "Discharging" ]]; then
        icon="󰂁"
    else
        icon="󰁹"
    fi

    battery_module="$icon $capacity%"
fi

# Network
network_module="$NET_DOWN_ICON"

default_iface=$(ip route 2>/dev/null | awk '/^default/ {print $5; exit}')
if [ -n "$default_iface" ]; then
    if [[ $(cat /sys/class/net/"$default_iface"/type) -eq 1 ]]; then
        if [[ $default_iface == wl* ]]; then
            network_module="$NET_WIFI_ICON"
        else
            network_module="$NET_LAN_ICON"
        fi
    fi
fi

# Bluetooth
bluetooth_module=""

bluetooth_power=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [ "$bluetooth_power" = "yes" ]; then
    connected=$(bluetoothctl info | grep "Connected: yes")

    if [ -n "$connected" ]; then
        bluetooth_module="${BLUETOOTH_ICON}${BLUETOOTH_CONNECTED_ICON}"
    else
        bluetooth_module="$BLUETOOTH_ICON"
    fi
fi

# Notifications
notifications_module=""

if pidof dunst > /dev/null; then
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
fi

# Formatted final output with proper margin
# Margin... using spaces. Sorry not sorry :)
modules=()

[[ -n "$battery_module" ]]       && modules+=(" $battery_module")
[[ -n "$bluetooth_module" ]]     && modules+=("  $bluetooth_module")
[[ -n "$network_module" ]]       && modules+=("  $network_module")
[[ -n "$audio_module" ]]         && modules+=("  $audio_module")
[[ -n "$notifications_module" ]] && modules+=("  $notifications_module")
[[ -n "$keyboard_module" ]]      && modules+=(" $keyboard_module")
[[ -n "$date_module" ]]          && modules+=("    $date_module ")

echo "${modules[*]}"

