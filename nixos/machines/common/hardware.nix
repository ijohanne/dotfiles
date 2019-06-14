{ config, pkgs, ... }:

{
  hardware.enableAllFirmware = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };
  
  hardware.bluetooth = {
    enable = true;
    extraConfig = "
      [General]
      Enable=Source,Sink,Media,Socket
    ";
  };

  boot.initrd.luks.devices.decrypted-disk-name = {
    keyFile = "/keyfile.bin";
  };

  boot.loader = {
    efi.efiSysMountPoint = "/efi";

    grub = {
      device = "nodev";
      efiSupport = true;
      extraInitrd = "/boot/initrd.keys.gz";
      enableCryptodisk = true;
      zfsSupport = true;
    };

    grub.efiInstallAsRemovable = true;
    efi.canTouchEfiVariables = false;
  };
}