# Disable greeting prompt
set --erase fish_greeting

function fish_greeting 
end

# Init zoxide
zoxide init fish | source

# Enable direnv
eval (direnv export fish)

        case "switch"
                $HOME/.dotfiles/switch.sh
        case '*'
                echo "Only switch is supported"
end
alias home-manager="$HOME/.dotfiles/home-manager.sh"                        
alias nixos-rebuild="$HOME/.dotfiles/nixos-rebuild.sh"
alias nixfmt-recursive="find . -name \*nix -type f -exec nixfmt {} \;"
