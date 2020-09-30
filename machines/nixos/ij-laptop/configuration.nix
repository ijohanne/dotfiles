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

  networking.hostName = "ij-laptop";
  networking.hostId = "d4c95480";
  system.stateVersion = "19.03";

  nix.buildMachines = [{
    hostName = "builder";
    systems = [ "x86_64-linux" ];
    maxJobs = 4;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
