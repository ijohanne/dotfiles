{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.bat.enable) {
    home.packages = with pkgs; [ bat ];
  };
}

