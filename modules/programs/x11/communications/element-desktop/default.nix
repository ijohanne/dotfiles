{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.communications.element-desktop.enable) {
    home.packages = with pkgs; [ element-desktop ];
  };

}
