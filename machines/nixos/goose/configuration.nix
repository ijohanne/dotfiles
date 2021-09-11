{ pkgs, config, ... }:
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
      (import ./services { inherit secrets pkgs config; })
      ./networking.nix
    ];

  system.stateVersion = "21.05";
}
