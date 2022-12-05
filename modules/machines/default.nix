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
    scanners = mkOption {
      default = false;
      type = bool;
      description = "Preconfigure scanners";
    };
    desktop = mkOption {
      default = false;
      type = bool;
      description = "Enable desktop settings";
    };
    laptop = mkOption {
      default = false;
      type = bool;
      description = "Enable laptop settings";
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

  imports = [ ./users.nix ./desktop ./rpi ../lib ./laptop ];

  config = {
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        substituters = config.dotfiles.cachix.binaryCaches ++ [ "https://nix-community.cachix.org" "https://devenv.cachix.org" ];
        trusted-public-keys = config.dotfiles.cachix.binaryCachePublicKeys ++ [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
      };
    };
    environment.systemPackages = [ pkgs.man-pages ];
    nixpkgs.config.allowUnfree = true;
    documentation.dev.enable = true;
    nixpkgs.overlays = [ (import ../overlays) ];
  };
}
