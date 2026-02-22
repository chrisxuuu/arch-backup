#!/bin/bash

# Get default sink info
sink=$(pactl get-default-sink)
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

# Choose icon based on mute/volume
if [ "$muted" = "yes" ]; then
    icon=""
    text=" ${volume}%"
elif [ "$volume" -eq 0 ]; then
    icon=""
    text=" ${volume}%"
elif [ "$volume" -lt 50 ]; then
    icon=""
    text=" ${volume}%"
else
    icon=""
    text=" ${volume}%"
fi

# Get sink description for tooltip
description=$(pactl list sinks | grep -A5 "Name: $sink" | grep "Description:" | cut -d: -f2- | xargs)

echo "{\"text\": \"$text\", \"tooltip\": \"$description\", \"class\": \"audio\"}"
