{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/hardware/hardware.nix
    ../../../modules/hardware/network.nix
    ../../../modules/hardware/users.nix
    ../../../modules/hardware/general.nix

  ];

  networking.hostName = "ij-home";
  networking.hostId = "f6f3a438";
  system.stateVersion = "19.09";

}
