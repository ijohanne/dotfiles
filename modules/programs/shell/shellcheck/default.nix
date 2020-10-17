{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.dotfiles.shell.shellcheck.enable) {
    home.packages = with pkgs; [ shellcheck ];
  };
}

