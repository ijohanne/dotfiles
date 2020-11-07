{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.office.thunderbird.enable) {
    home.packages = with pkgs; [ thunderbird ];
  };
}

