{ ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
      ./users.nix
      ./security.nix
      ./services
      ./networking.nix
    ];

  system.stateVersion = "21.05";
}
