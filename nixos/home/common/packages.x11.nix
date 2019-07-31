{ pkgs, ... }:

{
  home.packages = with pkgs; [
    slack
    riot-desktop
    thunderbird
    libreoffice
    spotify
    pavucontrol
    bemenu
    termite
    inconsolata
    zathura
    seafile-client
    mako
    skype
    feh
    vpnc
    openconnect
  ];
}
