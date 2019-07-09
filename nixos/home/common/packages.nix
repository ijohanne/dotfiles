{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    slack
    riot-desktop
    kubectl
    thunderbird
    libreoffice
    spotify
    stack
    rustup
    pavucontrol
    bemenu
    termite
    lsof
    inconsolata
    zathura
    seafile-client
    mako
    whois
    skype
    nixfmt
    ripgrep
    mtr
    mkpasswd
    feh
    docker-compose
    haskellPackages.hp2pretty
  ];
}
