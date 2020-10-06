{ pkgs, ... }:

{
  imports = [
    ../programs/home-manager.nix
    ../programs/browsers
    ../programs/shell
    ../programs/development
    ../programs/window-managers
    ../programs/tex
    ../fonts-themes.nix
  ];

}

