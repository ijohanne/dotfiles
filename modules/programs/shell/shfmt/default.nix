{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.shfmt.enable) {
    home.packages = with pkgs; [ shfmt ];
  };

}

