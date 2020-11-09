{ pkgs, lib, config, ... }:
with lib; {
  config = mkIf (config.dotfiles.machines.desktop) (mkMerge [
    {
      hardware.enableAllFirmware = true;
      hardware.pulseaudio = {
        enable = true;
        extraModules = [ pkgs.pulseaudio-modules-bt ];
        package = pkgs.pulseaudioFull;
      };

      hardware.bluetooth = {
        enable = true;
        config.General.Enable = "Source,Sink,Media,Socket";
      };

      hardware.opengl = {
        enable = true;
        driSupport = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
          vaapiIntel
          intel-media-driver
        ];
      };

      boot.loader = {
        systemd-boot = {
          enable = true;
          editor = false;
          configurationLimit = 10;
          memtest86.enable = true;
        };
        efi.canTouchEfiVariables = true;
      };

      services.fwupd.enable = true;

      boot.kernelPackages = pkgs.linuxPackages_5_9;

      boot.zfs.enableUnstable = true;
    }
    (mkIf
      (config.dotfiles.user-settings.yubikey.luks-gpg.public-key-file
        != null
        && config.dotfiles.user-settings.yubikey.luks-gpg.encrypted-pass-file
        != null)
      {
        boot.initrd.luks = {
          gpgSupport = true;
          devices.decrypted-root = {
            gpgCard = {
              publicKey =
                config.dotfiles.user-settings.yubikey.luks-gpg.public-key-file;
              encryptedPass =
                config.dotfiles.user-settings.yubikey.luks-gpg.encrypted-pass-file;
            };
          };
        };
      })
  ]);
}
