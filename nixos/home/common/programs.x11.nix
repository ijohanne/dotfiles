let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [];};
in {
  programs.firefox = { enable = true; };

}
