{ pkgs, ... }:
let
  secrets = (import ./secrets.nix);
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
      ./users.nix
      ./security.nix
      (import ./services { inherit secrets pkgs; })
      ./networking.nix
    ];

  system.stateVersion = "21.05";
}
