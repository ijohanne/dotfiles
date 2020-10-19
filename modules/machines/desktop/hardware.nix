{ pkgs, lib, config, ... }:
with lib; {
  config = lib.mkIf (config.dotfiles.machines.desktop) {
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

    # Bluetooth security issue, so override if testing is still not newer than 5.9.1
    boot.kernelPackages =
      if (lib.versionOlder pkgs.linux_testing.version "5.9.1") then
        (pkgs.linuxPackagesFor (pkgs.linux_testing.override {
          argsOverride = rec {
            src = pkgs.fetchurl {
              url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
              sha256 = "0dn0xz81pphca5dkg6zh8c78p05f63rrr5ihqqsmhc4n73li2jms";
            };
            version = "5.9.1";
            modDirVersion = "5.9.1";
          };
        }))
      else
        pkgs.linux_testing;

    boot.zfs.enableUnstable = true;
  };
}

