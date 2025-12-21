#!/bin/bash

# Power menu script for Waybar + rofi
# Save this to ~/.config/waybar/scripts/power-menu.sh

options="⏾ Suspend\n⭮ Restart\n⏻ Shutdown\n🔒 Lock"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" \
    -theme-str 'window {width: 400px;}' \
    -theme-str 'listview {lines: 4;}' \
    -theme-str 'inputbar {children: [prompt];}')

case $chosen in
"⏾ Suspend")
    systemctl suspend
    ;;
"⭮ Restart")
    systemctl reboot
    ;;
"⏻ Shutdown")
    systemctl poweroff
    ;;
"🔒 Lock")
    # Try different lock commands in order of preference
    if command -v hyprlock &>/dev/null; then
        hyprlock
    elif command -v swaylock &>/dev/null; then
        swaylock
    else
        # If no locker is installed, notify the user
        notify-send "No screen locker found" "Please install hyprlock or swaylock"
    fi
    ;;
esac
