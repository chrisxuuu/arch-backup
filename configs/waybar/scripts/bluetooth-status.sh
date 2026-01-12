#!/bin/bash

# Get Bluetooth status
bluetooth_status=$(bluetoothctl show 2>/dev/null | grep "Powered" | awk '{print $2}')
bluetooth_connected=$(bluetoothctl devices Connected 2>/dev/null | wc -l)

# Build icon
if [ "$bluetooth_status" = "yes" ]; then
    if [ "$bluetooth_connected" -gt 0 ]; then
        icon="󰂱"
        tooltip="Bluetooth: $bluetooth_connected device(s) connected"
    else
        icon="󰂯"
        tooltip="Bluetooth: On"
    fi
else
    icon="󰂲"
    tooltip="Bluetooth: Off"
fi

# Output JSON for Waybar
echo "{\"text\":\"$icon\", \"tooltip\":\"$tooltip\"}"