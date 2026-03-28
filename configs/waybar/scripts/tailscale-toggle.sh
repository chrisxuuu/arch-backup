#!/bin/bash

status=$(systemctl is-active tailscaled 2>/dev/null)

if [ "$status" = "active" ]; then
    sudo systemctl stop tailscaled
else
    sudo systemctl start tailscaled
fi
