{ pkgs, lib, config, ... }:
let sources = import ../../../../nix/sources.nix;
in {
  config = lib.mkIf (config.dotfiles.shell.nix-linter.enable) {
    home.packages =
      [ (import sources.nix-linter { inherit pkgs; }).nix-linter ];
  };
}

