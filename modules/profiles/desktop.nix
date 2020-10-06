{ pkgs, ... }:

{
  imports = [
    ../programs/home-manager.nix
    ../programs/browsers
    ../programs/shell
    ../programs/development
    ../programs/window-managers
    ../programs/tex
    ../programs/x11
    ../fonts-themes.nix
  ];

}

