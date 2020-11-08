{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.tokei.enable) {
    home.packages = with pkgs; [ tokei ];
  };
}
