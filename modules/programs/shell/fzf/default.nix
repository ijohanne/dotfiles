{ pkgs, lib, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.shell.fzf.enable) {
    home.packages = with pkgs; [ fzf ];
    programs.fish = {
      plugins = with pkgs.fishPlugins; [ fzf-fish ];
      shellInit = ''
        fzf_configure_bindings
      '';
    };
  };
}
