{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.onefetch.enable) {
    home.packages = with pkgs; [ onefetch ];
  };

}
