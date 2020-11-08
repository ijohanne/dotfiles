{ pkgs, lib, config, ... }:
with lib;
let fishPlugins = pkgs.callPackage ../fish/fish-plugins.nix { };
in
{
  config = mkIf (config.dotfiles.shell.exa.enable) {
    home.packages = with pkgs; [ exa ];
    programs.fish = {
      plugins = with fishPlugins; [ fish-exa ];
      shellInit = ''
        source ${fishPlugins.fish-exa.src}/functions/l.fish
        source ${fishPlugins.fish-exa.src}/functions/ll.fish
      '';
    };
  };

}
