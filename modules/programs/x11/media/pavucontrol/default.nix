{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.media.pavucontrol) {
    home.packages = with pkgs; [ pavucontrol ];
  };
}

