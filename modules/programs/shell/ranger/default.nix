{ pkgs, lib, config, ... }:
with lib;
let sources = import ../../../../nix/sources.nix;
in {
  config = mkIf (config.dotfiles.shell.ranger.enable) {
    home.packages = with pkgs; [ ranger ];
    programs.neovim = {
      extraConfig = builtins.readFile ../../../../configs/neovim/ranger.vim;
      plugins = with pkgs; [
        (pkgs.callPackage ../../development-tools/neovim/vim-plugins.nix
          { }).ranger-vim
        vimPlugins.bclose-vim
      ];
    };
    xdg.configFile = {
      "ranger/rc.conf".text = ''
        default_linemode devicons
        set preview_images false
        set vcs_aware true
      '';
      "ranger/plugins/ranger_devicons".source = sources.ranger_devicons;
    };
  };
}

