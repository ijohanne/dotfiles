{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.ruplacer.enable) {
    home.packages = with pkgs; [ ruplacer ];
  };
}
