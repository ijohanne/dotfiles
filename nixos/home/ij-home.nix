{ pkgs, ... }:

let
  nixgenerators = import (builtins.fetchTarball
    "https://github.com/nix-community/nixos-generators/archive/master.tar.gz")
    { };
in {
  nixpkgs.overlays = [ (import ./overlays/package-upgrades) ];

  imports = [
    ./common/fonts-themes.nix
    ./common/packages.shell.nix
    ./common/packages.tex.nix
    ./common/packages.x11.nix
    ./common/programs.shell.nix
    ./common/programs.x11.nix
    ./common/programs.local.nix
    ./common/services.shell.nix
    ./common/services.x11.nix
    ./common/files.nix
    ./common/environment.nix
  ];

  home.packages = [ nixgenerators ];
}
