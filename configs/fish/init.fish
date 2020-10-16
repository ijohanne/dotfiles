# Disable greeting prompt
set --erase fish_greeting

function fish_greeting
end

# Init zoxide
zoxide init fish | source

# Enable direnv
eval (direnv export fish)

# Set proper title
function fish_title
    echo (hostname): (pwd): $argv[1]

    switch "$TERM"
        case 'screen*'
            if set -q SSH_CLIENT
                set maybehost (hostname):
            else
                set maybehost ""
            end
            echo -ne "\\ek"$maybehost(status current-command)"\\e\\" >/dev/tty
    end
end

#alias home-manager="$HOME/.dotfiles/home-manager.sh"
#alias nixos-rebuild="$HOME/.dotfiles/nixos-rebuild.sh"
#alias nixfmt-recursive="find . -name \*nix -type f -exec nixfmt {} \;"

