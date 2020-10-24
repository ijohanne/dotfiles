{ lib, config, ... }:
let sources = import ../../../../nix/sources.nix;
in {
  config = lib.mkIf (config.dotfiles.shell.nix-tree.enable) {
    home.packages = [ (import sources.nix-tree).nix-tree ];
  };
}

