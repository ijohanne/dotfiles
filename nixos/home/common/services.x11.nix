let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [ ]; };
in { services.network-manager-applet.enable = true; }
