{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.office.thunderbird) {
    home.packages = with pkgs; [ thunderbird ];
  };
}

