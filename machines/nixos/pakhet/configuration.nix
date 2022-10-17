{ ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
      ./networking.nix
      ./users.nix
    ];
  system.stateVersion = "22.05";
}

