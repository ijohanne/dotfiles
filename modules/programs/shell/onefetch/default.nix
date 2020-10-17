{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.onefetch.enable) {
    home.packages = with pkgs; [ onefetch ];
  };

}

