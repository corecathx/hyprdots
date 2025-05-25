#!/bin/bash

BAT0_PATH="/sys/class/power_supply/BAT0"
BAT1_PATH="/sys/class/power_supply/BAT1"

# Read battery information
read -r BAT0_ENERGY_NOW < "$BAT0_PATH/energy_now"
read -r BAT0_ENERGY_FULL < "$BAT0_PATH/energy_full"
read -r BAT1_ENERGY_NOW < "$BAT1_PATH/energy_now"
read -r BAT1_ENERGY_FULL < "$BAT1_PATH/energy_full"

# Calculate total energy and percentage
TOTAL_ENERGY_NOW=$((BAT0_ENERGY_NOW + BAT1_ENERGY_NOW))
TOTAL_ENERGY_FULL=$((BAT0_ENERGY_FULL + BAT1_ENERGY_FULL))
BATTERY_PERCENTAGE=$(awk "BEGIN {printf \"%.1f\", ($TOTAL_ENERGY_NOW / $TOTAL_ENERGY_FULL) * 100}")

# Map icons based on percentage
if (( $(echo "$BATTERY_PERCENTAGE < 20" | bc -l) )); then
    ICON="battery_1_bar"
elif (( $(echo "$BATTERY_PERCENTAGE < 40" | bc -l) )); then
    ICON="battery_2_bar"
elif (( $(echo "$BATTERY_PERCENTAGE < 60" | bc -l) )); then
    ICON="battery_4_bar"
elif (( $(echo "$BATTERY_PERCENTAGE < 80" | bc -l) )); then
    ICON="battery_5_bar"
else
    ICON="battery_full"
fi

# Check charging status
BAT0_STATUS=$(<"$BAT0_PATH/status")
BAT1_STATUS=$(<"$BAT1_PATH/status")

if [[ $BAT0_STATUS == "Charging" || $BAT1_STATUS == "Charging" ]]; then
    ICON="bolt"
fi

# Apply red color when battery is below 15%
if (( $(echo "$BATTERY_PERCENTAGE < 15" | bc -l) )); then
    if [[ $BAT0_STATUS == "Charging" || $BAT1_STATUS == "Charging" ]]; then
    COLOR=""
    else
    COLOR="foreground='red'"
    
    fi
else
    COLOR=""
fi

echo "<span font='Material Symbols Rounded' size='x-large' rise='-4pt' $COLOR>$ICON</span><span $COLOR>$BATTERY_PERCENTAGE%</span>"
