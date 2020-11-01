{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.media.vlc) {
    home.packages = with pkgs; [ vlc ];
  };
}

