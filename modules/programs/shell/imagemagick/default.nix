{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.imagemagick.enable) {
    home.packages = with pkgs; [ imagemagick ];
  };
}

