#!/bin/bash

# Icons
WIFI_SIGNAL_0="signal_wifi_0_bar"
WIFI_SIGNAL_1="network_wifi_1_bar"
WIFI_SIGNAL_2="network_wifi_2_bar"
WIFI_SIGNAL_3="network_wifi_3_bar"
WIFI_SIGNAL_4="signal_wifi_4_bar"
WIFI_ICON_DISCONNECTED="signal_wifi_off"
ETH_ICON_CONNECTED="settings_ethernet"
BLUETOOTH_ICON_CONNECTED="bluetooth"
BLUETOOTH_ICON_DISCONNECTED="bluetooth_disabled"

# Check network connection type
NET_ICON=""
if nmcli -t -f DEVICE,TYPE,STATE dev | grep -q "ethernet:connected"; then
    NET_ICON="$ETH_ICON_CONNECTED"
elif nmcli radio wifi | grep -q "enabled"; then
    # Check Wi-Fi status
    WIFI_SIGNAL=$(nmcli -t -f IN-USE,SIGNAL dev wifi | grep '^*' | cut -d: -f2)
    if [[ -n $WIFI_SIGNAL ]]; then
        if (( WIFI_SIGNAL >= 75 )); then
            NET_ICON="$WIFI_SIGNAL_4"
        elif (( WIFI_SIGNAL >= 50 )); then
            NET_ICON="$WIFI_SIGNAL_3"
        elif (( WIFI_SIGNAL >= 25 )); then
            NET_ICON="$WIFI_SIGNAL_2"
        elif (( WIFI_SIGNAL > 0 )); then
            NET_ICON="$WIFI_SIGNAL_1"
        else
            NET_ICON="$WIFI_SIGNAL_0"
        fi
    fi
fi

# Check Bluetooth status
BT_ICON=""
if bluetoothctl show | grep -q "Powered: yes"; then
    BT_ICON="$BLUETOOTH_ICON_DISCONNECTED"
    if [[ $(bluetoothctl devices Connected | wc -l) -gt 0 ]]; then
        BT_ICON="$BLUETOOTH_ICON_CONNECTED"
    fi
fi

# Build output string
OUTPUT=""
SPACING=""
if [[ -n $NET_ICON ]]; then
    OUTPUT+="<span font='Material Symbols Rounded' size='large' rise='-4pt'>$NET_ICON</span>"
    SPACING="    ";
fi
if [[ -n $BT_ICON ]]; then
    OUTPUT+="$SPACING<span font='Material Symbols Rounded' size='large' rise='-4pt'>$BT_ICON</span>"
fi

echo "$OUTPUT"
