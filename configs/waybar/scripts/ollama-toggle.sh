#!/bin/bash

status=$(systemctl is-active ollama 2>/dev/null)

if [ "$status" = "active" ]; then
    sudo systemctl stop ollama
else
    sudo systemctl start ollama
fi
