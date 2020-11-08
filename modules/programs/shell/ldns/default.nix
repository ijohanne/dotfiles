{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.ldns.enable) {
    home.packages = with pkgs; [ ldns ];
  };
}
