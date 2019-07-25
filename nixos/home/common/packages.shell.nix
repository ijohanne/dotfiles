{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    kubectl
    stack
    rustup
    lsof
    whois
    nixfmt
    ripgrep
    mtr
    mkpasswd
    docker-compose
    haskellPackages.hp2pretty
  ];
}
