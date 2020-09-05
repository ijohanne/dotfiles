{ pkgs, ... }:

{
  nixpkgs.overlays = [ (import ./overlays/package-upgrades) ];

  imports = [
    ./common/fonts-themes.nix
    ./common/packages.shell.nix
    ./common/packages.x11.nix
    ./common/programs.shell.nix
    ./common/programs.x11.nix
    ./common/services.nix
    ./common/files.nix
    ./common/environment.nix
  ];

  home.sessionVariables = { DRI_PRIME = "1"; };
}
