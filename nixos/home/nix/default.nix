let
  sources = import ./sources.nix;
in
rec {
  home-manager = sources.home-manager;
  pkgs = sources.nixos-unstable;
  nixpkgs = sources.nixpkgs;
  nur = import sources.NUR;
  neovim-overlay = import sources.neovim-overlay;
}