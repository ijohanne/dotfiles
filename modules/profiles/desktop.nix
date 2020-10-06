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

  home.sessionVariables = {
    EDITOR = "vim";
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    MOZ_ENABLE_WAYLAND = "1";
    DRI_PRIME = "1";
  };

}

