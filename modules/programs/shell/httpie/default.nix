{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.httpie.enable) {
    home.packages = with pkgs; [ httpie ];
  };
}

