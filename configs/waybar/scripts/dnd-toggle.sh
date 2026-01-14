#!/bin/bash

# Toggle Do Not Disturb for mako
STATUS_FILE="$HOME/.config/mako/dnd_status"

toggle_dnd() {
    if [ -f "$STATUS_FILE" ]; then
        # DND is ON, turn it OFF
        rm "$STATUS_FILE"
        makoctl mode -s default
    else
        # DND is OFF, turn it ON
        touch "$STATUS_FILE"
        makoctl mode -a dnd
    fi
    # Force waybar to update
    pkill -RTMIN+1 waybar
}

get_status() {
    if [ -f "$STATUS_FILE" ]; then
        # DND is ON - using moon icon or slash bell
        echo '{"text": " 󰂛 ", "class": "dnd-on", "tooltip": "Do Not Disturb: ON"}'
    else
        # DND is OFF - using bell icon
        echo '{"text": " 󰂚 ", "class": "dnd-off", "tooltip": "Do Not Disturb: OFF"}'
    fi
}

case "$1" in
    toggle)
        toggle_dnd
        get_status
        ;;
    *)
        get_status
        ;;
esac
