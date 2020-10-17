{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.x11.communications.element-desktop) {
    home.packages = with pkgs; [ element-desktop ];
  };

}
