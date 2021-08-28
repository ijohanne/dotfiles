{ config, pkgs, lib, ... }:
let
  secrets = (import ./secrets.nix);
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
    ];

  system.stateVersion = "21.05";
}
