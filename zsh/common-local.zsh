# Load local override if it exists
if [ -f $HOME/.zshrc.local ]
then
  source $HOME/.zshrc.local
fi

# Generate shortform key entries in $HOME/.ssh/known_hosts
function build_ssh_knownhosts_unixpimpsboxes {
  rm $HOME/.ssh/known_hosts;
  local hosts=(amstel bluemoon chimay fosters guinness heineken leffe)
  hosts+=(miller paulaner sanmiguel strongbow tuborg urquell)
  hosts+=(urquell.unixpimps.net)
  hosts+=("10.255.30.10" "10.255.30.11" "10.255.30.12")
  for hst in $hosts; do
    ssh-keyscan $hst >> $HOME/.ssh/known_hosts;
  done
}

# Also allow IPs in auto-complete of hostnames
zstyle ':completion:*' use-ip true

# Do not glob scp and http/https/ftp
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
zstyle -e :urlglobber url-other-schema \
'[[ $words[1] == scp ]] && reply=("*") || reply=(http https ftp)'

# Override theme prompt with 24h and remove hg
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;30m%}@%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%Y-%m-%d %H:%M:%S"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}%?$(retcode)%{\e[0;34m%}%B] <$(mygit)>%{\e[0m%}%b '

if [ ! -d $HOME/.cache/oh-my-zsh ] ;
then 
    mkdir -p $HOME/.cache/oh-my-zsh
fi

fn nixfmt-recursive() {
  find . -name \*nix -exec nixfmt {} \;
}

source $HOME/.dotfiles/zsh/zsh-nix-shell/nix-shell.plugin.zsh
