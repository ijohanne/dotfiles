{ pkgs, ... }: {
  home.packages = with pkgs; [
    #    kubectl
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
    perl
  ];
}
