{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.du-dust.enable) {
    home.packages = with pkgs; [ du-dust ];
    programs.fish.shellAliases = { du = "${pkgs.du-dust}/bin/dust"; };
  };
}
