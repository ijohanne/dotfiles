{ ... }:

{
  imports =
    [ ../../users/ij ./hardware-configuration.nix ../../../modules/machines ];

  dotfiles.machines.laptop = true;
  dotfiles.machines.printers = true;

  networking.hostName = "ij-laptop";
  networking.hostId = "d035f711";
  system.stateVersion = "20.03";

  networking.firewall.allowedTCPPorts = [ 8080 ];

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
