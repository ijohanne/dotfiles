{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.development-tools.perl.enable) {
    home.packages = with pkgs; [ perl ];
  };
}

