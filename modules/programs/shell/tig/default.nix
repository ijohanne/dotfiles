{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.tig.enable) {
    home.packages = with pkgs; [ tig ];
  };
}

