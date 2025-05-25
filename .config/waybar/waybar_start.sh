#!/bin/bash

CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"
chmod +x ./custom/*

trap "killall -SIGUSR2 waybar" EXIT

while true; do
    waybar &
    inotifywait -e create,modify $CONFIG_FILES
    killall -9 waybar
done