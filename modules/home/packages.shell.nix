{ pkgs, ... }: {
  home.packages = with pkgs; [
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
    gitAndTools.gh
  ];
}
