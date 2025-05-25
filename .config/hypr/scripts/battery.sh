#!/bin/bash
# Used in: hyprlock.conf

BAT0_PATH="/sys/class/power_supply/BAT0"
BAT1_PATH="/sys/class/power_supply/BAT1"

read -r BAT0_ENERGY_NOW < "$BAT0_PATH/energy_now"
read -r BAT0_ENERGY_FULL < "$BAT0_PATH/energy_full"
read -r BAT1_ENERGY_NOW < "$BAT1_PATH/energy_now"
read -r BAT1_ENERGY_FULL < "$BAT1_PATH/energy_full"

TOTAL_ENERGY_NOW=$((BAT0_ENERGY_NOW + BAT1_ENERGY_NOW))
TOTAL_ENERGY_FULL=$((BAT0_ENERGY_FULL + BAT1_ENERGY_FULL))
BATTERY_PERCENTAGE=$(awk "BEGIN {printf \"%.2f\", ($TOTAL_ENERGY_NOW / $TOTAL_ENERGY_FULL) * 100}")

BAT0_STATUS=$(<"$BAT0_PATH/status")
BAT1_STATUS=$(<"$BAT1_PATH/status")

if [[ $BAT0_STATUS == "Charging" || $BAT1_STATUS == "Charging" ]]; then
    echo "• $BATTERY_PERCENTAGE% (Charging)"
else
    echo "• $BATTERY_PERCENTAGE%"
fi

