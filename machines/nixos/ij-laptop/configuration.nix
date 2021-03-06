{ pkgs, ... }:

{
  imports =
    [ ../../users/ij ./hardware-configuration.nix ../../../modules/machines ];

  dotfiles.machines.desktop = true;
  dotfiles.machines.printers = true;
  dotfiles.machines.linuxKernelTestingEnabled = true;
  dotfiles.machines.linuxKernelPackagesPkg = pkgs.linuxPackages_5_12;

  networking.hostName = "ij-laptop";
  networking.hostId = "d035f711";
  system.stateVersion = "20.03";

  nix.buildMachines = [{
    hostName = "builder";
    systems = [ "x86_64-linux" "aarch64-linux" ];
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
