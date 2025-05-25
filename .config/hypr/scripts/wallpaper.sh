#!/usr/bin/env bash

# This script is originally from end-4 Hyprland Dotfiles.
# Used in: hypr/main/keybinds.conf

dunstify -a "Hyprland" Hyprland "Pick a wallpaper."

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="$XDG_CONFIG_HOME/ags"

switch() {
	imgpath=$1
	read scale screenx screeny screensizey < <(hyprctl monitors -j | jq '.[] | select(.focused) | .scale, .x, .y, .height' | xargs)
	cursorposx=$(hyprctl cursorpos -j | jq '.x' 2>/dev/null) || cursorposx=960
	cursorposx=$(bc <<< "scale=0; ($cursorposx - $screenx) * $scale / 1")
	cursorposy=$(hyprctl cursorpos -j | jq '.y' 2>/dev/null) || cursorposy=540
	cursorposy=$(bc <<< "scale=0; ($cursorposy - $screeny) * $scale / 1")
	cursorposy_inverted=$((screensizey - cursorposy))

	if [ "$imgpath" == '' ]; then
		echo 'Aborted'
		exit 0
	fi

	swww img "$imgpath" --transition-step 100 --transition-fps 120 \
		--transition-type grow --transition-angle 30 --transition-duration 1 \
		--transition-pos "$cursorposx, $cursorposy_inverted"
}

if [ "$1" == "--noswitch" ]; then
	imgpath=$(swww query | awk -F 'image: ' '{print $2}')
elif [[ "$1" ]]; then
	switch "$1"
else
    cd "$(xdg-user-dir PICTURES)" || return 1
	switch "$(yad --width 1200 --height 800 --file --add-preview --large-preview --title='Choose wallpaper')"
fi

wal -i $imgpath
sleep 1
killall waybar && waybar & disown
killall dunst && dunst & disown

dunstify -a "Hyprland" Hyprland "Wallpaper has been set!"
