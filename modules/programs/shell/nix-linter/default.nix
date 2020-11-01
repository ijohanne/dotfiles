{ pkgs, lib, config, ... }:
with lib;
let sources = import ../../../../nix/sources.nix;
in {
  config = mkIf (config.dotfiles.shell.nix-linter.enable) {
    home.packages =
      [ (import sources.nix-linter { inherit pkgs; }).nix-linter ];
  };
}

