{ pkgs, lib, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.shell.ranger.enable) {
    home.packages = with pkgs; [ ranger ];
    programs.neovim = {
      extraConfig = builtins.readFile ../../../../configs/neovim/ranger.vim;
      plugins = with pkgs.vimPlugins; [
        ranger-vim
        bclose-vim
      ];
    };
    xdg.configFile = {
      "ranger/rc.conf".text = ''
        default_linemode devicons
        set preview_images false
        set vcs_aware true
      '';
      "ranger/plugins/ranger_devicons".source = pkgs.niv-sources.ranger_devicons;
    };
  };
}
