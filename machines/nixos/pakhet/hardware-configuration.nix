{ ... }:
{
  imports = [ ];
  boot.initrd.availableKernelModules = [ "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/5276400d-e977-41ae-8ebc-444d2d2f3514";
      fsType = "ext4";
    };
  swapDevices = [ ];
  hardware.cpu.amd.updateMicrocode = false;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
