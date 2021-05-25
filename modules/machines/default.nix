{ pkgs, lib, config, ... }:
with lib; {
  options.dotfiles.machines = with types; {
    rpi = mkOption {
      default = false;
      type = bool;
      description = "Enable Raspberry Pi settings";
    };
    printers = mkOption {
      default = false;
      type = bool;
      description = "Preconfigure printers";
    };
    desktop = mkOption {
      default = false;
      type = bool;
      description = "Enable desktop settings";
    };
    linuxKernelTestingEnabled = mkOption {
      default = false;
      type = bool;
      description = "Enable the linux testing kernel";
    };
    linuxKernelPackagesPkg = mkOption {
      default = pkgs.linuxPackages_latest;
      type = attrs;
      description = "Default latest Linux kernel package to use";
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
