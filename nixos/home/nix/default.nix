let
  sources = import ./sources.nix;
  pkgs = import sources.nixpkgs { };
in rec {
  home-manager = sources.home-manager;
  nixpkgs = sources.nixpkgs;
  nur = import sources.NUR { inherit pkgs; };
  neovim-overlay = import sources.neovim-overlay;
  mozilla-overlay = import sources.mozilla-overlay;
}
