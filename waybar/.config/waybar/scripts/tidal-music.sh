#!/bin/bash

# Check if plasma-browser-integration player exists (regardless of playing/paused status)
status=$(playerctl -p plasma-browser-integration status 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$status" ]; then
    # Player exists, get the URL to verify it's from Tidal
    url=$(playerctl -p plasma-browser-integration metadata xesam:url 2>/dev/null)

    if echo "$url" | grep -q "tidal.com"; then
        # It's Tidal, show the metadata
        playerctl -p plasma-browser-integration metadata --format='{{ artist }} - {{ title }}' 2>/dev/null
    fi
fi
