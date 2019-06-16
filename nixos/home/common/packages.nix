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
  ];
}
