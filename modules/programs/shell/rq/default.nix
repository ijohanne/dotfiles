{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.rq.enable) {
    home.packages = with pkgs; [ rq ];
  };
}

