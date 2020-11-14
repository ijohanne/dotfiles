{ pkgs, lib, config, ... }:
with lib;
{
  config = mkIf (config.dotfiles.shell.fish.enable) {
    home.packages = with pkgs; [ python3Minimal ];

    programs.fish = {
      enable = true;
      shellInit = ''
        eval (${pkgs.coreutils}/bin/dircolors -c "${pkgs.niv-sources.LS_COLORS.outPath}/LS_COLORS")
          set --erase fish_greeting
      '';
      shellAliases = {
        home-manager = "$HOME/.dotfiles/home-manager.sh";
        niv-home = "$HOME/.dotfiles/niv-home.sh";
        nixos-rebuild = "$HOME/.dotfiles/nixos-rebuild.sh";
      };
      plugins = with pkgs.fishPlugins; [
        bass
        oh-my-fish-plugin-foreign-env
        oh-my-fish-plugin-ssh
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
  };

}
