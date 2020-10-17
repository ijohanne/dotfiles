{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.media.spotify) {
    home.packages = with pkgs; [ spotify ];
  };
}

