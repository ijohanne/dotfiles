{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.bat.enable) {
    home.packages = with pkgs; [ bat ];
  };
}
