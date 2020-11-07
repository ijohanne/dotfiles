{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.media.feh.enable) {
    home.packages = with pkgs; [ feh ];
  };
}

