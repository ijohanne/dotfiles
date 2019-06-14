{ pkgs, ... }:

{
  nixpkgs.overlays = [ (import ./overlays/package-upgrades) ];
  
  imports =
    [
      ./common/fonts-themes.nix
      ./common/packages.nix
      ./common/programs.nix
      ./common/services.nix
      ./common/files.nix
      ./common/environment.nix
    ];

  programs.vscode = {
    userSettings = {
      "window.zoomLevel" = -2;
    };
  };

}
