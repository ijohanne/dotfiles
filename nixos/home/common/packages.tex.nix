let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [ ]; };
in { home.packages = with pkgs; [ texlive.combined.scheme-full ]; }

