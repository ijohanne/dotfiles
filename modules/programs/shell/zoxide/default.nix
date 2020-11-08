{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.zoxide.enable) {
    home.packages = with pkgs; [ zoxide ];
    programs.fish.shellInit = ''
      ${pkgs.zoxide}/bin/zoxide init fish | source
    '';
  };
}
