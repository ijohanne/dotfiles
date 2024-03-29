{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.fonts.enable) {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [ inconsolata inconsolata-nerdfont ];
    gtk = {
      enable = true;
      font = {
        name = "DejaVu Sans 10";
        package = pkgs.dejavu_fonts;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };
      theme = {
        name = "Equilux";
        package = pkgs.equilux-theme;
      };
    };
  };
}
