{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.media.feh) {
    home.packages = with pkgs; [ feh ];
  };
}

