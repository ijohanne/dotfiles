{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.media.vlc) {
    home.packages = with pkgs; [ vlc ];
  };
}

