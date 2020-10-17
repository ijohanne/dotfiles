{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.ldns.enable) {
    home.packages = with pkgs; [ ldns ];
  };
}

