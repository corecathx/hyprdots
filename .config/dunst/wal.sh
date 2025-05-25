#!/bin/sh

pkill swaync;
#wal -i "../../Pictures/cropped.jpeg"
sleep 1;
rm dunstrc
# Symlink dunst config
ln -sf ~/.cache/wal/dunstrc ~/.config/dunst/dunstrc

# Restart dunst with the new color scheme
pkill dunst
dunst &

#./test.sh