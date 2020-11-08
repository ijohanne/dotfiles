{ pkgs, lib, config, ... }:
with lib;
let fishPlugins = pkgs.callPackage ../fish/fish-plugins.nix { };
in
{
  config = mkIf (config.dotfiles.shell.fzf.enable) {
    home.packages = with pkgs; [ fzf ];
    programs.fish.plugins = with fishPlugins; [ fish-fzf ];
  };
}
