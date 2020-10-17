{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.office.libreoffice) {
    home.packages = with pkgs; [ libreoffice ];
  };
}

