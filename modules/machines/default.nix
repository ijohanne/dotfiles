{ lib, ... }:
with lib; {
  options.dotfiles.machines = {
    rpi = mkOption {
      default = false;
      type = types.bool;
      description = "Enable Raspberry Pi settings";
    };
    printers = mkOption {
      default = false;
      type = types.bool;
      description = "Preconfigure printers";
    };
    desktop = mkOption {
      default = false;
      type = types.bool;
      description = "Enable desktop settings";
    };
  };

  imports = [ ./packages.nix ./users.nix ./desktop ./rpi ../lib ];

  config = {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

  };
}
