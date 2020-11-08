{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.lsof.enable) {
    home.packages = with pkgs; [ lsof ];
  };

}
