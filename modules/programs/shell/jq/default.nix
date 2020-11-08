{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.jq.enable) {
    home.packages = with pkgs; [ jq ];
  };
}
