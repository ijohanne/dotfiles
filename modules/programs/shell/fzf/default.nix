{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.fzf.enable) {
    home.packages = with pkgs; [ fzf ];
  };
}

