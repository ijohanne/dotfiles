{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.tig.enable) {
    home.packages = with pkgs; [ tig ];
  };
}

