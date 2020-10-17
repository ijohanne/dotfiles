{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.tokei.enable) {
    home.packages = with pkgs; [ tokei ];
  };
}

