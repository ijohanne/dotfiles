{ config, pkgs, lib, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_5_13;
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot/ESP0"; }
      { devices = [ "nodev" ]; path = "/boot/ESP1"; }
    ];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  environment.etc."mdadm.conf".text = ''
    HOMEHOST delirium
  '';
  boot.initrd.mdadmConf = config.environment.etc."mdadm.conf".text;
}
