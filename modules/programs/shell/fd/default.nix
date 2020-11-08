{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.fd.enable) {
    home.packages = with pkgs; [ fd ];
  };
}
