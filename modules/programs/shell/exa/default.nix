{ pkgs, lib, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.shell.exa.enable) {
    home.packages = with pkgs; [ exa ];
    programs.fish = with pkgs.fishPlugins; {
      plugins = [ fish-exa ];
      shellInit = ''
        source ${fish-exa.src}/functions/l.fish
        source ${fish-exa.src}/functions/ll.fish
      '';
    };
  };

}
