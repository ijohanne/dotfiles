{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.jq.enable) {
    home.packages = with pkgs; [ jq ];
  };
}

