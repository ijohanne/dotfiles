{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.terminals.alacritty) {
    home.packages = with pkgs; [ alacritty libsixel ];

    xdg.configFile."alacritty/alacritty.yml".source =
      ../../../../../configs/terminal/alacritty.yml;
  };
}

