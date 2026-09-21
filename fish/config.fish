source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
end

alias spotify spotify-launcher
starship init fish | source

# uv
fish_add_path "/home/ramos/.local/share/../bin"
