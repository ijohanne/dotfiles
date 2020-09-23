{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/hardware.nix
    ../common/network.nix
    ../common/users.nix
    ../common/general.nix

  ];

  networking.hostName = "ij-home";
  networking.hostId = "f6f3a438";
  system.stateVersion = "19.09";

}
