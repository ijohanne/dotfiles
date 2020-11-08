{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.bottom.enable) {
    home.packages = with pkgs; [ bottom ];
    programs.fish.shellAliases = { top = "${pkgs.bottom}/bin/btm"; };
  };
}
