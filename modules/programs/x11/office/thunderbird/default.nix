{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.office.thunderbird) {
    home.packages = with pkgs; [ thunderbird ];
  };
}

