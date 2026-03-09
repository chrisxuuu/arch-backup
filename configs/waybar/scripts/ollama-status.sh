#!/bin/bash

status=$(systemctl is-active ollama 2>/dev/null)

if [ "$status" = "active" ]; then
    echo '{"text":"OLLAMA ON", "tooltip":"Ollama: Running\nClick to stop", "class":"running"}'
else
    echo '{"text":"OLLAMA OFF", "tooltip":"Ollama: Stopped\nClick to start", "class":"stopped"}'
fi
