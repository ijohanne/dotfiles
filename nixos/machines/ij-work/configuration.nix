{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/hardware.nix
    ../common/network.nix
    ../common/users.nix
    ../common/general.nix
  ];

  networking.hostName = "ij-work";
  networking.hostId = "81727bb7";
  system.stateVersion = "19.03";
}
