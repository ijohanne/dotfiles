{ config, pkgs, lib, ... }:
let
  secrets = (import ./secrets.nix);
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./users.nix
      ./networking.nix
      ./security.nix
      ./common.nix
      ./virtualhosts.nix
      (import ./services { inherit secrets config pkgs lib; })
      (import (./martin8412.nix) { inherit secrets config pkgs lib; })
      (import (./krumme.nix) { inherit secrets config pkgs lib; })
      (import (./izabella.nix) { inherit secrets config pkgs lib; })
      (import (./sniffy.nix) { inherit secrets config pkgs lib; })
      ./opsplaza.nix
    ];
  system.stateVersion = "21.05";
}
