{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.media.cider.enable) {
    home.packages = with pkgs; [ cider ];
  };
}
