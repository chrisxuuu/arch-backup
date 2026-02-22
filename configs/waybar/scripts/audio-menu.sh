#!/bin/bash

# Get current default sink
current_sink=$(pactl get-default-sink)

# Get all sinks
sinks=$(pactl list sinks short | awk '{print $2}')

# Build menu
menu=""

while read -r sink; do
    # Get friendly description
    description=$(pactl list sinks | grep -A5 "Name: $sink" | grep "Description:" | cut -d: -f2- | xargs)

    if [ "$sink" = "$current_sink" ]; then
        menu="$menu\n  $description 󰄬"
    else
        menu="$menu\n  $description"
    fi
done <<<"$sinks"

# Add settings option
menu="$menu\n  Audio Settings"

# Show rofi menu
choice=$(echo -e "$menu" | rofi -dmenu -i \
    -theme-str 'window {width: 400px;}' \
    -theme-str 'listview {lines: 10;}' \
    -theme-str 'inputbar {enabled: false;}' \
    -theme-str 'prompt {enabled: false;}' \
    -no-lazy-grab)

[ -z "$choice" ] && exit 0

case "$choice" in
*"Audio Settings")
    pavucontrol &
    ;;
*)
    # Find the sink matching the chosen description
    while read -r sink; do
        description=$(pactl list sinks | grep -A5 "Name: $sink" | grep "Description:" | cut -d: -f2- | xargs)
        if echo "$choice" | grep -q "$description"; then
            pactl set-default-sink "$sink"
            # Also move all active streams to new sink
            pactl list sink-inputs short | awk '{print $1}' | while read -r input; do
                pactl move-sink-input "$input" "$sink"
            done
            break
        fi
    done <<<"$sinks"
    ;;
esac
