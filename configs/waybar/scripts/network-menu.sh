#!/bin/bash

# Network menu using rofi
# This script provides a dropdown menu for WiFi and Bluetooth controls

# Get current status
wifi_status=$(nmcli radio wifi)
bluetooth_status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

# Build menu options
menu="󰖩  WiFi Settings\n  Bluetooth Settings\n──────────────"

# WiFi options
if [ "$wifi_status" = "enabled" ]; then
    menu="$menu\n󰖪  Disable WiFi"
    # Add available networks
    networks=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | head -5)
    if [ -n "$networks" ]; then
        menu="$menu\n──────────────"
        while IFS=: read -r ssid signal security; do
            if [ -n "$ssid" ]; then
                icon="󰤨"
                [ "$signal" -lt 50 ] && icon="󰤥"
                [ "$signal" -lt 25 ] && icon="󰤢"
                lock=""
                [ -n "$security" ] && lock=" 󰌾"
                menu="$menu\n$icon  $ssid$lock ($signal%)"
            fi
        done <<< "$networks"
    fi
else
    menu="$menu\n󰖩  Enable WiFi"
fi

# Bluetooth options
menu="$menu\n──────────────"
if [ "$bluetooth_status" = "yes" ]; then
    menu="$menu\n  Disable Bluetooth"
    # Add connected devices
    devices=$(bluetoothctl devices Connected)
    if [ -n "$devices" ]; then
        menu="$menu\n──────────────"
        while read -r line; do
            device_name=$(echo "$line" | cut -d' ' -f3-)
            menu="$menu\n  $device_name"
        done <<< "$devices"
    fi
else
    menu="$menu\n  Enable Bluetooth"
fi

# Show menu
choice=$(echo -e "$menu" | rofi -dmenu -i -p "Network" \
    -theme-str 'window {width: 400px;}' \
    -theme-str 'listview {lines: 12;}')

# Handle selection
case "$choice" in
    *"WiFi Settings")
        nm-connection-editor &
        ;;
    *"Bluetooth Settings")
        blueman-manager &
        ;;
    *"Enable WiFi")
        nmcli radio wifi on
        ;;
    *"Disable WiFi")
        nmcli radio wifi off
        ;;
    *"Enable Bluetooth")
        bluetoothctl power on
        ;;
    *"Disable Bluetooth")
        bluetoothctl power off
        ;;
    *)
        # Check if it's a WiFi network
        if echo "$choice" | grep -q "󰤨\|󰤥\|󰤢"; then
            ssid=$(echo "$choice" | sed -E 's/^[^ ]+ +//; s/ 󰌾.*//')
            # Attempt to connect
            if echo "$choice" | grep -q "󰌾"; then
                # Network is secured, prompt for password
                password=$(rofi -dmenu -p "Password for $ssid" -password)
                if [ -n "$password" ]; then
                    nmcli dev wifi connect "$ssid" password "$password"
                fi
            else
                nmcli dev wifi connect "$ssid"
            fi
        fi
        ;;
esac