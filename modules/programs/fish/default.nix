{ pkgs, config, ... }:
let
  sources = import ../../../nix/sources.nix;
  fishPlugins = pkgs.callPackage ./fish-plugins.nix { };
  dots = "${config.home.homeDirectory}/.dotfiles";
in {

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ../../../configs/fish/init.fish;
    plugins = with fishPlugins; [
      bass
      oh-my-fish-plugin-ssh
      oh-my-fish-plugin-foreign-env
      fish-fzf
      fish-ssh-agent
    ];
  };

  home.file = {
    ".dircolors".source = sources.LS_COLORS.outPath + "/LS_COLORS";
  };
}

