{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.scc.enable) {
    home.packages = with pkgs; [ scc ];
  };

}
