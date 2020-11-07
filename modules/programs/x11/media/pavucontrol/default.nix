{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.media.pavucontrol.enable) {
    home.packages = with pkgs; [ pavucontrol ];
  };
}

