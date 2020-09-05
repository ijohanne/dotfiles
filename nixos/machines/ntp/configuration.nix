{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/network-rpi.nix
    ../common/users.nix
    ../common/general-rpi.nix

  ];

  networking.hostName = "ntp";
  system.stateVersion = "20.09";

}

