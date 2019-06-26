{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans 10";
      package = pkgs.dejavu_fonts;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = {
      name = "Equilux";
      package = pkgs.equilux-theme;
    };
  };
}
