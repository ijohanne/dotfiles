let
  sources = import ../nix;
  pkgs = import sources.nixpkgs { overlays = [];};
in {
  home.packages = with pkgs; [
    htop
    kubectl
    rustup
    lsof
    whois
    haskellPackages.nixfmt
    ripgrep
    mtr
    mkpasswd
    docker-compose
    ldns
    imagemagick
    niv
  ];
}
