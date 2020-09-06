let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [];};
in {
  services.gpg-agent.enable = true;
  services.lorri.enable = true;
}
