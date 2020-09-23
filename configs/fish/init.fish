# Disable greeting prompt
set --erase fish_greeting

function fish_greeting 
end

# Init zoxide
zoxide init fish | source

# Enable direnv
eval (direnv export fish)
