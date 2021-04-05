{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.development-tools.act.enable) {
    home.packages = with pkgs; [ act ];
  };
}
