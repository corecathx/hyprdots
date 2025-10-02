#!/bin/bash

config_items=(
    "hypr"
    "cava"
    "fish"
    "whisker"
    "starship.toml"
    "matugen"
    "fastfetch"
    "kitty"
    "qt5ct"
    "qt6ct"
    "gtk-3.0"
    "gtk-4.0"
)

dest="./.config"

if [ -d "$dest" ]; then
    read -p "destination '$dest' already exists. do you want to clear it first? [y/N] " answer
    case "$answer" in
        [Yy]* )
            echo "clearing $dest..."
            rm -rf "$dest"
            ;;
        * )
            echo "keeping existing contents."
            ;;
    esac
fi

mkdir -p "$dest"

reflected=0
not_found=0
errors=0
missing_items=()

for item in "${config_items[@]}"; do
    src="$HOME/.config/$item"
    if [ -e "$src" ]; then
        echo "copying $item..."
        if cp -r "$src" "$dest/"; then
            ((reflected++))
        else
            echo "error copying $item"
            ((errors++))
        fi
    else
        echo "warning: $item not found in ~/.config"
        ((not_found++))
        missing_items+=("$item")
    fi
done

total=${#config_items[@]}

echo
echo "reflection complete!"
echo "--------------------"
echo "total items:    $total"
echo "reflected:      $reflected"
echo "not found:      $not_found"
echo "errors:         $errors"

if [ $not_found -gt 0 ]; then
    echo -n "missing items:  "
    printf "%s, " "${missing_items[@]}" | sed 's/, $//'
    echo
fi
