{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    kubectl
    stack
    rustup
    lsof
    whois
    haskellPackages.nixfmt
    ripgrep
    mtr
    mkpasswd
    docker-compose
    haskellPackages.hp2pretty
    ldns
    texlive.combined.scheme-full
    imagemagick
    dive
  ];
}
