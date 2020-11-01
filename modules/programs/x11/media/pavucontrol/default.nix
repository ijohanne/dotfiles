{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.media.pavucontrol) {
    home.packages = with pkgs; [ pavucontrol ];
  };
}

