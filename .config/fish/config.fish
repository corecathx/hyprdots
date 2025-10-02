if status is-interactive
    set fish_greeting
end

starship init fish | source

if test -f ~/.config/fish/aliases/self.fish
    source ~/.config/fish/aliases/self.fish
end