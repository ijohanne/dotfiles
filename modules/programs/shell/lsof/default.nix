{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.lsof.enable) {
    home.packages = with pkgs; [ lsof ];
  };

}

