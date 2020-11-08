{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.ripgrep.enable) {
    home.packages = with pkgs; [ ripgrep ];
  };

}
