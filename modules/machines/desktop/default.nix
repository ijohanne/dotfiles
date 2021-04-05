{ lib, ... }:
with lib; {
  imports = [ ./general.nix ./hardware.nix ./printers.nix ./network.nix ];
  config = {
    networking.extraHosts = ''
      127.0.0.1 app-frontend.local app-backend.local app-frontend-old.local
    '';
  };
}
