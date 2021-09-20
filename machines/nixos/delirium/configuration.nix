{ config, pkgs, lib, ... }:
let
  secrets = (import ./secrets.nix);
  sources = (import /home/ij/.dotfiles/nix/sources.nix);
  ijohanne-nur = import sources.ijohanne-nur-packages { inherit pkgs; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./users.nix
      ./networking.nix
      ./security.nix
      ./common.nix
      (import ./services { inherit secrets config pkgs lib; })
      (import ./hosted { inherit secrets config pkgs lib; })
      ijohanne-nur.modules.prometheus-teamspeak3-exporter
    ];

  nixpkgs.overlays = [
    (import "${sources.ijohanne-nur-packages}/overlay.nix")
  ];

  system.stateVersion = "21.05";
}
