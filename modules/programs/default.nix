{ config, lib, ... }:
with lib; {
  options.dotfiles = {
    browsers.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable browser programs";
    };
    window-managers.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable window manager programs";
    };
    shell.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable shell programs";
    };
    virtualization.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable virtualization programs";
    };
    tex.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable TeX programs";
    };
    development-tools.enable = mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable development programs";
    };
  };

  imports = [
    ./home-manager.nix
    ./packages.nix
    ../lib
    ./user-settings.nix
    ./browsers
    ./window-managers
    ./x11
    ./shell
    ./virtualization
    ./tex
    ./development-tools
  ];

  config = {
    xdg.configFile."Yubico/u2f_keys".text =
      concatStringsSep "\n" config.dotfiles.user-settings.yubikey.u2f-keys;
  };
}

