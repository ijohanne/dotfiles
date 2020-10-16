{ pkgs, ... }:
let
  sources = import ../../../../nix/sources.nix;
  fishPlugins = pkgs.callPackage ./fish-plugins.nix { };
in {

  home.packages = with pkgs; [ python3Minimal ];

  programs.fish = {
    enable = true;
    shellInit = ''
      eval (${pkgs.coreutils}/bin/dircolors -c "${sources.LS_COLORS.outPath}/LS_COLORS")
      source ${fishPlugins.fish-exa.src}/functions/l.fish
      source ${fishPlugins.fish-exa.src}/functions/ll.fish
      set --erase fish_greeting
      ${pkgs.zoxide}/bin/zoxide init fish | source
    '';
    shellAliases = {
      home-manager = "$HOME/.dotfiles/home-manager.sh";
      nixos-rebuild = "$HOME/.dotfiles/nixos-rebuild.sh";
      nix = "$HOME/.dotfiles/nix.sh";
      niv-update = "$HOME/.dotfiles/update-niv.sh";
    };
    plugins = with fishPlugins; [
      bass
      oh-my-fish-plugin-ssh
      oh-my-fish-plugin-foreign-env
      fish-fzf
      fish-ssh-agent
      fish-exa
    ];
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

}

