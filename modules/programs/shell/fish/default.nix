{ pkgs, lib, config, ... }:
with lib;
let
  sources = import ../../../../nix/sources.nix;
  fishPlugins = pkgs.callPackage ./fish-plugins.nix { };
in {
  config = lib.mkIf (config.dotfiles.shell.fish.enable) {
    home.packages = with pkgs; [ python3Minimal ];

    programs.fish = {
      enable = true;
      shellInit = let
        exaStr = if config.dotfiles.shell.exa.enable then ''
          source ${fishPlugins.fish-exa.src}/functions/l.fish
          source ${fishPlugins.fish-exa.src}/functions/ll.fish
        '' else
          "";
        zoxideStr = if config.dotfiles.shell.zoxide.enable then ''
          ${pkgs.zoxide}/bin/zoxide init fish | source
            '' else
          "";
      in ''
        eval (${pkgs.coreutils}/bin/dircolors -c "${sources.LS_COLORS.outPath}/LS_COLORS")
        set --erase fish_greeting
        ${exaStr}
        ${zoxideStr}
      '';
      shellAliases = {
        home-manager = "$HOME/.dotfiles/home-manager.sh";
        niv-home = "$HOME/.dotfiles/niv-home.sh";
        nixos-rebuild = "$HOME/.dotfiles/nixos-rebuild.sh";
      };
      plugins = with fishPlugins;
        [ bass oh-my-fish-plugin-foreign-env ]
        ++ optionals (config.dotfiles.shell.fzf.enable) [ fish-fzf ]
        ++ optionals (config.dotfiles.shell.exa.enable) [ fish-exa ];
      functions = {
        fish_greeting = { body = ""; };
        fish_title = {
          body = ''
            echo (hostname): (pwd): $argv[1]
            switch "$TERM"
              case 'screen*'
                if set -q SSH_CLIENT
                  set maybehost (hostname):
                else
                 set maybehost ""
               end
              echo -ne "\\ek"$maybehost(status current-command)"\\e\\" >/dev/tty
            end
          '';
        };
      };
    };
  };

}

