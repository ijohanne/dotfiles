{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.development-tools.perl.enable) {
    home.packages = with pkgs; [ perl ];
  };
}

