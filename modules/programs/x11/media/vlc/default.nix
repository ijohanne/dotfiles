{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.media.vlc.enable) {
    home.packages = with pkgs; [ vlc ];
  };
}
