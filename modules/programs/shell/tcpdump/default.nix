{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.tcpdump.enable) {
    home.packages = with pkgs; [ tcpdump ];
  };

}

