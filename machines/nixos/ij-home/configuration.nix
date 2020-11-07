{ ... }:

{
  imports =
    [ ./hardware-configuration.nix ../../../modules/machines ../../users/ij ];

  dotfiles.machines.desktop = true;
  dotfiles.machines.printers = true;

  networking.hostName = "ij-home";
  networking.hostId = "f6f3a438";
  system.stateVersion = "19.09";

}
