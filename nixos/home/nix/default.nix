let sources = import ./sources.nix;
in rec {
  home-manager = sources.home-manager;
  nixpkgs = sources.nixpkgs;
  nur = sources.NUR;
  neovim-overlay = import sources.neovim-overlay;
  mozilla-overlay = import sources.mozilla-overlay;
}
