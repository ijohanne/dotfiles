{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/machines/hardware.nix
    ../../../modules/machines/network.nix
    ../../../modules/machines/users.nix
    ../../../modules/machines/general.nix
    ../../../modules/machines/packages.nix
  ];

  networking.hostName = "ij-home";
  networking.hostId = "f6f3a438";
  system.stateVersion = "19.09";

}
