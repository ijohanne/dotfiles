{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.office.prusa-slicer.enable) {
    home.packages = with pkgs; [ prusa-slicer ];
  };
}
