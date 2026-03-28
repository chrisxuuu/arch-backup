#!/bin/bash

status=$(systemctl is-active tailscaled 2>/dev/null)

if [ "$status" = "active" ]; then
    echo '{"text":"TS ON", "tooltip":"Tailscale: Running\nClick to stop", "class":"running"}'
else
    echo '{"text":"TS OFF", "tooltip":"Tailscale: Stopped\nClick to start", "class":"stopped"}'
fi
