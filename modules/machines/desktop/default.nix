{ lib, ... }:
with lib; {
  options.dotfiles.machines = with types; {
    zfsEnable = mkOption {
      default = false;
      type = bool;
      description = "Enable ZFS for this system";
    };
  };
  imports = [ ./general.nix ./hardware.nix ./printers.nix ./network.nix ];
  config = {
    networking.extraHosts = ''
      127.0.0.1 app-frontend.local app-backend.local www.app-frontend.local
    '';
  };
}
