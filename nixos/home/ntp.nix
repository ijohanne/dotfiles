{ pkgs, ... }:

{
  nixpkgs.overlays = [ (import ./overlays/package-upgrades) ];

  imports = [
    ./common/fonts-themes.nix
    ./common/packages.shell.nix
    ./common/programs.shell.nix
    ./common/programs.remote.nix
    ./common/files.nix
    ./common/environment.nix
    ./common/services.shell.nix
  ];

  dconf.enable = false;

}
