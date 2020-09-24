{ pkgs, ... }: {
  imports = [ ./packages.nix ];
  home.packages = with pkgs; [ texlive.combined.scheme-full ];
}

