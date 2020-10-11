{ pkgs, ... }:
let sources = import ../../../../nix/sources.nix;
in {
  home.packages = [ (import sources.nix-linter { inherit pkgs; }).nix-linter ];
}

