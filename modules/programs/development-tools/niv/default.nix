{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.development-tools.niv.enable) {
    home.packages = with pkgs.niv; [ niv ];
  };
}
