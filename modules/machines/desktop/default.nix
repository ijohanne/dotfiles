{ lib, ... }:
with lib; {
  imports = [ ./general.nix ./hardware.nix ./printers.nix ./network.nix ];
}
