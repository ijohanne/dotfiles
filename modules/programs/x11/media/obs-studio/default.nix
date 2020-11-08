{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.media.obs-studio.enable) {
    home.packages = with pkgs; [ obs-studio ];
  };
}
