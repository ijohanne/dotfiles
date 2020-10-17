{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.media.feh) {
    home.packages = with pkgs; [ feh ];
  };
}

