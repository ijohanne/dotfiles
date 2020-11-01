{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.imagemagick.enable) {
    home.packages = with pkgs; [ imagemagick ];
  };
}

