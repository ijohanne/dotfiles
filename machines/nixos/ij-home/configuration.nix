{ ... }:

{
  imports = [ ./hardware-configuration.nix ../../../modules/machines ];

  dotfiles.machines.desktop = true;

  networking.hostName = "ij-home";
  networking.hostId = "f6f3a438";
  system.stateVersion = "19.09";

}
