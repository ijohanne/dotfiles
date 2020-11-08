{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.tcpdump.enable) {
    home.packages = with pkgs; [ tcpdump ];
  };

}
