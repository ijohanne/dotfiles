{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.zoxide.enable) {
    home.packages = with pkgs; [ zoxide ];
  };

}

