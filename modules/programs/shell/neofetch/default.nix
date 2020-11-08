{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.neofetch.enable) {
    home.packages = with pkgs; [ neofetch ];
  };
}
