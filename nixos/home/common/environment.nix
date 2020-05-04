{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "vim";
    TERM = "xterm";
    GDK_BACKEND = "wayland";
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };
}
