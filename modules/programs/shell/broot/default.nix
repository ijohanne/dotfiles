{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.broot.enable) {
    home.packages = with pkgs; [ broot ];
    programs.fish.shellAliases = { tree = "${pkgs.broot}/bin/broot"; };
  };
}

