{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.media.obs-studio) {
    home.packages = with pkgs; [ obs-studio ];
  };
}

