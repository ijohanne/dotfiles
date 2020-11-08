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

      boot.initrd.secrets = {
        "/keyfile.bin" = "/etc/secrets/initrd/keyfile.bin";
      };

      boot.loader = {
        efi.efiSysMountPoint = "/efi";
        grub = {
          device = "nodev";
          efiSupport = true;
          enableCryptodisk = true;
          zfsSupport = true;
          copyKernels = true;
        };
        grub.efiInstallAsRemovable = true;
        efi.canTouchEfiVariables = false;
      };

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
          devices.decrypted-disk-name = {
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
