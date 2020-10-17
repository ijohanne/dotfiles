{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.development-tools.niv.enable) {
    home.packages = with pkgs.niv; [ niv ];
  };
}

