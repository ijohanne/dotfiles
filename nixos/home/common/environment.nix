{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "vim";
    TERM = "xterm";
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
