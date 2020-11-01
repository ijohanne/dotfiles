{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.shell.shellcheck.enable) {
    home.packages = with pkgs; [ shellcheck ];
  };
}

