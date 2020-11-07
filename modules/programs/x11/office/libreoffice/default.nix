{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.office.libreoffice.enable) {
    home.packages = with pkgs; [ libreoffice ];
  };
}

