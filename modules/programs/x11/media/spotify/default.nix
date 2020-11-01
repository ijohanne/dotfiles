{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.media.spotify) {
    home.packages = with pkgs; [ spotify ];
  };
}

