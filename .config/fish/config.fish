function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

starship init fish | source

alias cleanup="pacman -Qqtd | sudo pacman -Rsu - && sudo pacman -Scc"
alias hyprconfig="nano ~/.config/hypr/hyprland/general.conf"
alias screenconfig="nano ~/.config/hypr/custom/general.conf"
alias fishconfig="nano ~/.config/fish/config.fish"
alias show-fixes="nano ~/Documents/Fixes/list"
alias reload-waybar="pkill waybar && waybar & disown"
alias logout="hyprctl dispatch exit"
alias twsconnect="bluetoothctl connect 41:42:FF:BB:22:CF"
cat ~/.cache/wal/sequences &
