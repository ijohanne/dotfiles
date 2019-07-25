{ pkgs, ... }:

{
  nixpkgs.overlays = [ (import ./overlays/package-upgrades) ];

  imports = [
    ./common/fonts-themes.nix
    ./common/packages.shell.nix
    ./common/packages.x11.nix
    ./common/programs.shell.nix
    ./common/services.x11.nix
    ./common/files.nix
    ./common/environment.nix
  ];

  programs.vscode = { userSettings = { "window.zoomLevel" = -1; }; };

}
