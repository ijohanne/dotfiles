{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.lfs.enable) {
    home.packages = with pkgs; [ lfs ];
    programs.fish.shellAliases = { df = "${pkgs.lfs}/bin/lfs"; };
  };
}

