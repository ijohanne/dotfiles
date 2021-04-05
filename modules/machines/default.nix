{ pkgs, lib, config, ... }:
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
    linuxKernelTestingEnabled = mkOption {
      default = false;
      type = types.bool;
      description = "Enable the linux testing kernel";
    };
  };

  imports = [ ./users.nix ./desktop ./rpi ../lib ];

  config = {
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      binaryCaches = config.dotfiles.cachix.binaryCaches;
      binaryCachePublicKeys = config.dotfiles.cachix.binaryCachePublicKeys;
    };
    environment.systemPackages = [ pkgs.manpages ];
    nixpkgs.config.allowUnfree = true;
    documentation.dev.enable = true;
    nixpkgs.overlays = [ (import ../overlays) ];
  };
}
