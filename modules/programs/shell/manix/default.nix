{ pkgs, lib, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.shell.manix.enable) {
    home.packages = with pkgs; [ manix ];
  };
}
