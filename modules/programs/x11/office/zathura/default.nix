{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.office.zathura) {
    home.packages = with pkgs; [ zathura ];
  };
}

