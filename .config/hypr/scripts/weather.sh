#!/bin/bash
# Used in: hyprlock.conf

CITY=$(curl -s https://ipinfo.io/city 2>/dev/null)
COUNTRY=$(curl -s https://ipinfo.io/country 2>/dev/null)

if [[ -n "$CITY" ]]; then
    weather_info=$(curl -s "wttr.in/$CITY?format=%c+%C+%t" 2>/dev/null)

    if [[ -n "$weather_info" ]]; then
        echo "🏙️ $COUNTRY - $CITY: $weather_info"
    else
        echo "Weather info unavailable for $CITY"
    fi
else
    echo "Unable to determine your location"
fi
