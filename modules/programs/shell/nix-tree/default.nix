{ lib, config, ... }:
with lib;
let sources = import ../../../../nix/sources.nix;
in {
  config = mkIf (config.dotfiles.shell.nix-tree.enable) {
    home.packages = [ (import sources.nix-tree).nix-tree ];
  };
}

