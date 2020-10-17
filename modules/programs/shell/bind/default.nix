{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.bind.enable) {
    home.packages = with pkgs; [ bind ];
  };
}

