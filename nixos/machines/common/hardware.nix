{ config, pkgs, ... }:

let
  unstable = import (builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs-channels/archive/nixpkgs-unstable.tar.gz") {
      config = config.nixpkgs.config;
    };
in {
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

  boot.initrd.luks.devices.decrypted-disk-name = { keyFile = "/keyfile.bin"; };

  boot.loader = {
    efi.efiSysMountPoint = "/efi";

    grub = {
      device = "nodev";
      efiSupport = true;
      extraInitrd = "/boot/initrd.keys.gz";
      enableCryptodisk = true;
      zfsSupport = true;
      copyKernels = true;
    };

    grub.efiInstallAsRemovable = true;
    efi.canTouchEfiVariables = false;
  };

  boot.kernelPackages = unstable.linuxPackages_5_6;
}
