#!/bin/bash

# Get WiFi status
wifi_status=$(nmcli radio wifi)

# Build menu options
menu=""

# WiFi toggle
if [ "$wifi_status" = "enabled" ]; then
    menu="󰖪  Disable WiFi"
else
    menu="󰖩  Enable WiFi"
fi

# Add settings option
menu="$menu\n󰖩  WiFi Settings"

# If WiFi is enabled, show available networks
if [ "$wifi_status" = "enabled" ]; then
    # Get current connection
    current=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2)
    
    # Add current network first if connected
    if [ -n "$current" ]; then
        signal=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d':' -f2)
        
        # Choose icon based on signal
        if [ "$signal" -ge 75 ]; then
            icon="󰤨"
        elif [ "$signal" -ge 50 ]; then
            icon="󰤥"
        elif [ "$signal" -ge 25 ]; then
            icon="󰤢"
        else
            icon="󰤟"
        fi
        
        menu="$menu\n$icon  $current 󰄬 (Connected)"
        menu="$menu\n──────────────────────"
    fi
    
    # Get available networks (limit to 10)
    networks=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | head -10)
    
    if [ -n "$networks" ]; then
        while IFS=: read -r ssid signal security; do
            # Skip if this is the current network (already shown)
            if [ -n "$ssid" ] && [ "$ssid" != "$current" ]; then
                # Choose icon based on signal
                if [ "$signal" -ge 75 ]; then
                    icon="󰤨"
                elif [ "$signal" -ge 50 ]; then
                    icon="󰤥"
                elif [ "$signal" -ge 25 ]; then
                    icon="󰤢"
                else
                    icon="󰤟"
                fi
                
                # Add lock icon if secured
                lock=""
                [ -n "$security" ] && [ "$security" != "--" ] && lock=" 󰌾"
                
                menu="$menu\n$icon  $ssid$lock"
            fi
        done <<< "$networks"
    fi
fi

# Show menu with rofi (no search bar)
choice=$(echo -e "$menu" | rofi -dmenu -i \
    -theme-str 'window {width: 400px;}' \
    -theme-str 'listview {lines: 12;}' \
    -theme-str 'inputbar {enabled: false;}' \
    -theme-str 'prompt {enabled: false;}' \
    -no-lazy-grab)

# Exit if nothing selected
[ -z "$choice" ] && exit 0

# Handle selection
case "$choice" in
    *"WiFi Settings")
        nm-connection-editor &
        ;;
    *"Enable WiFi")
        nmcli radio wifi on
        ;;
    *"Disable WiFi")
        nmcli radio wifi off
        ;;
    " "|"──────────────────────")
        # Ignore spacer lines and horizontal separators
        ;;
    *)
        # Check if it's a WiFi network
        if echo "$choice" | grep -q "󰤨\|󰤥\|󰤢\|󰤟"; then
            # Extract SSID (remove icon, lock, and connected indicator)
            ssid=$(echo "$choice" | sed -E 's/^[^ ]+ +//; s/ 󰌾//; s/ 󰄬.*//')
            
            # Check if network is secured
            if echo "$choice" | grep -q "󰌾"; then
                # Network is secured, prompt for password with two separate boxes
                password=$(echo "" | rofi -dmenu \
                    -p "Password for $ssid" \
                    -password \
                    -theme-str 'window {width: 400px;}' \
                    -theme-str 'mainbox {children: [message, inputbar];}' \
                    -theme-str 'message {padding: 10px; border: 2px; border-radius: 8px; background-color: rgba(68, 75, 106, 0.3);}' \
                    -theme-str 'textbox {text-color: #a9b1d6;}' \
                    -theme-str 'inputbar {children: [entry]; padding: 10px; margin: 10px 0px 0px 0px; border: 2px; border-radius: 8px; background-color: rgba(68, 75, 106, 0.3);}' \
                    -theme-str 'entry {placeholder: "Enter password";}' \
                    -theme-str 'listview {enabled: false;}' \
                    -mesg "Password for $ssid" \
                    -no-lazy-grab)
                
                if [ -n "$password" ]; then
                    nmcli dev wifi connect "$ssid" password "$password"
                fi
            else
                nmcli dev wifi connect "$ssid"
            fi
        fi
        ;;
esac