{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.x11.office.zathura.enable) {
    home.packages = with pkgs; [ zathura ];
  };
}
