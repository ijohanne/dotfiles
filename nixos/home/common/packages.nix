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
    xlockmore
    rofi
    xautolock
  ];
}
