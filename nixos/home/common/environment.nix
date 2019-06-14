{ pkgs, ... }:

{
    home.sessionVariables = {
      EDITOR = "vim";
      #GDK_BACKEND= "wayland";
      #CLUTTER_BACKEND = "wayland";
    };
}
