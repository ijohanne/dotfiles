{ config, sources ? import ../../nixpkgs, pkgs ? import sources.nixpkgs {}, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/hardware.nix
    ../common/network.nix
    ../common/users.nix
    ../common/general.nix
  ];

  networking.hostName = "ij-laptop";
  networking.hostId = "d4c95480";
  system.stateVersion = "19.03";
}
