#!/bin/bash

# Get Bluetooth status
bluetooth_status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

# Build menu options
menu=""

# Bluetooth toggle
if [ "$bluetooth_status" = "yes" ]; then
    menu="  Disable Bluetooth"
else
    menu="  Enable Bluetooth"
fi

# Add settings option
menu="$menu\n  Bluetooth Settings"

# If Bluetooth is on, show paired devices
if [ "$bluetooth_status" = "yes" ]; then
    # Get paired devices
    devices=$(bluetoothctl devices Paired)
    
    if [ -n "$devices" ]; then
        # Add spacer
        menu="$menu\n "
        
        while read -r line; do
            mac=$(echo "$line" | awk '{print $2}')
            name=$(echo "$line" | cut -d' ' -f3-)
            
            # Check if device is connected
            connected=$(bluetoothctl info "$mac" | grep "Connected: yes")
            
            if [ -n "$connected" ]; then
                menu="$menu\n  $name 󰄬"
            else
                menu="$menu\n  $name"
            fi
        done <<< "$devices"
    fi
fi

# Show menu with rofi (no search bar)
choice=$(echo -e "$menu" | rofi -dmenu -i \
    -theme-str 'window {width: 400px;}' \
    -theme-str 'listview {lines: 10;}' \
    -theme-str 'inputbar {enabled: false;}' \
    -theme-str 'prompt {enabled: false;}' \
    -no-lazy-grab)

# Exit if nothing selected
[ -z "$choice" ] && exit 0

# Handle selection
case "$choice" in
    *"Bluetooth Settings")
        blueman-manager &
        ;;
    *"Enable Bluetooth")
        rfkill unblock bluetooth 2>/dev/null
        bluetoothctl power on
        ;;
    *"Disable Bluetooth")
        bluetoothctl power off
        ;;
    " ")
        # Ignore spacer lines
        ;;
    *)
        # Check if it's a device
        if echo "$choice" | grep -q ""; then
            # Extract device name (remove icon and connected mark)
            device_name=$(echo "$choice" | sed -E 's/^[^ ]+ +//; s/ 󰄬//')
            
            # Find MAC address by name
            mac=$(bluetoothctl devices Paired | grep "$device_name" | awk '{print $2}')
            
            if [ -n "$mac" ]; then
                # Check if device is connected
                connected=$(bluetoothctl info "$mac" | grep "Connected: yes")
                
                if [ -n "$connected" ]; then
                    # Disconnect
                    bluetoothctl disconnect "$mac"
                else
                    # Connect
                    bluetoothctl connect "$mac"
                fi
            fi
        fi
        ;;
esac