#!/bin/bash

# Get WiFi status
wifi_status=$(nmcli -t -f STATE general)
wifi_connected=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2)

# Get Bluetooth status
bluetooth_status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
bluetooth_connected=$(bluetoothctl devices Connected | wc -l)

# Build icon string
icon=""
tooltip=""

# WiFi icon
if [ "$wifi_status" = "connected (local only)" ] || [ "$wifi_status" = "connected (site only)" ] || [ "$wifi_status" = "connected" ]; then
    if [ -n "$wifi_connected" ]; then
        icon="  $wifi_connected"
        tooltip="WiFi: $wifi_connected"
    else
        icon=" "
        tooltip="WiFi: Connected"
    fi
else
    icon=" "
    tooltip="WiFi: Disconnected"
fi

# Bluetooth icon
if [ "$bluetooth_status" = "yes" ]; then
    if [ "$bluetooth_connected" -gt 0 ]; then
        icon="$icon  $bluetooth_connected"
        tooltip="$tooltip\nBluetooth: $bluetooth_connected device(s) connected"
    else
        icon="$icon "
        tooltip="$tooltip\nBluetooth: On"
    fi
else
    icon="$icon "
    tooltip="$tooltip\nBluetooth: Off"
fi

# Output JSON for Waybar
echo "{\"text\":\"$icon\", \"tooltip\":\"$tooltip\"}"