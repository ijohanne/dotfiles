{ pkgs, config, ... }:
let
  sources = import ../../../../nix/sources.nix;
  fishPlugins = pkgs.callPackage ./fish-plugins.nix { };
  dots = "${config.home.homeDirectory}/.dotfiles";
in {

  home.packages = with pkgs; [ python3Minimal ];

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ../../../../configs/fish/init.fish + ''
      eval (${pkgs.coreutils}/bin/dircolors -c "${sources.LS_COLORS.outPath}/LS_COLORS")
      source ${fishPlugins.fish-exa.src}/functions/l.fish
      source ${fishPlugins.fish-exa.src}/functions/ll.fish
      alias top=ytop
      alisa du=dust
    '';
    plugins = with fishPlugins; [
      bass
      oh-my-fish-plugin-ssh
      oh-my-fish-plugin-foreign-env
      fish-fzf
      fish-ssh-agent
      fish-exa
    ];
  };

}

