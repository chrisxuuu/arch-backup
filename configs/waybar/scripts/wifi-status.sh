#!/bin/bash

# Get WiFi status
wifi_status=$(nmcli -t -f STATE general)
wifi_connected=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2)

# Get signal strength
signal=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d':' -f2)

# Build icon based on signal strength
if [ "$wifi_status" = "connected (local only)" ] || [ "$wifi_status" = "connected (site only)" ] || [ "$wifi_status" = "connected" ]; then
    if [ -n "$signal" ]; then
        if [ "$signal" -ge 75 ]; then
            icon="󰤨"
        elif [ "$signal" -ge 50 ]; then
            icon="󰤥"
        elif [ "$signal" -ge 25 ]; then
            icon="󰤢"
        else
            icon="󰤟"
        fi
        tooltip="WiFi: $wifi_connected ($signal%)"
    else
        icon="󰤨"
        tooltip="WiFi: Connected"
    fi
else
    icon="󰤮"
    tooltip="WiFi: Disconnected"
fi

# Output JSON for Waybar
echo "{\"text\":\"$icon\", \"tooltip\":\"$tooltip\"}"
