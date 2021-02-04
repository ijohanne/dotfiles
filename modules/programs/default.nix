{ pkgs, config, lib, ... }:
with lib; {
  options.dotfiles = {
    browsers.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable browser programs";
    };
    window-managers.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable window manager programs";
    };
    shell.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable shell programs";
    };
    virtualization.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable virtualization programs";
    };
    tex.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable TeX programs";
    };
    development-tools.enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable development programs";
    };
  };

  imports = [
    ../lib
    ./tests
    ./browsers
    ./window-managers
    ./x11
    ./shell
    ./virtualization
    ./tex
    ./development-tools
  ];

  config = mkMerge [
    {
      nixpkgs.overlays = [
        (import ../overlays)
      ];
      nixpkgs.config = {
        allowUnfree = true;

        permittedInsecurePackages = [
          "libsixel-1.8.6"
        ];
      };
      home.sessionVariables = {
        NIX_PATH =
          "nixpkgs=${pkgs.niv-sources.nixpkgs}:home-manager=${pkgs.niv-sources.home-manager}:nixos-config=/etc/nixos/configuration.nix:nixpkgs-overlays=${config.dotfiles.user-settings.dotfiles-dir}/modules/overlays";
      };
      programs = {
        home-manager = {
          enable = true;
          path = "${pkgs.niv-sources.home-manager}";
        };
      };
    }
    (
      mkIf (config.dotfiles.user-settings.yubikey.username != null && (length (config.dotfiles.user-settings.yubikey.u2f-keys) > 0)) {
        xdg.configFile."Yubico/u2f_keys".text = "${config.dotfiles.user-settings.yubikey.username}:${concatStringsSep ":" config.dotfiles.user-settings.yubikey.u2f-keys}";
      }
    )
  ];
}
