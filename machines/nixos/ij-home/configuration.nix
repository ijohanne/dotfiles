{ ... }:

{
  imports =
    [ ./hardware-configuration.nix ../../../modules/machines ../../users/ij ];

  dotfiles.machines = {
    desktop = true;
    printers = true;
    scanners = true;
  };

  networking.hostName = "ij-home";
  networking.hostId = "df2c4b6d";
  system.stateVersion = "21.05";

}
