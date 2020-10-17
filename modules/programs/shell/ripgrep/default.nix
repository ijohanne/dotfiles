{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.ripgrep.enable) {
    home.packages = with pkgs; [ ripgrep ];
  };

}

