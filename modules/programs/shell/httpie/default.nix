{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.httpie.enable) {
    home.packages = with pkgs; [ httpie ];
  };
}
