{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/users.nix
    ../common/general-rpi.nix

  ];

  networking.hostName = "ntp";
  system.stateVersion = "20.09";

}

