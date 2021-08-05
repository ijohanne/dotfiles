{ lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "nvme" "usb_storage" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

  fileSystems."/var/data" =
    {
      device = "/dev/disk/by-label/data";
      fsType = "ext4";
    };


  fileSystems."/boot/ESP0" =
    {
      device = "/dev/disk/by-label/esp0";
      fsType = "vfat";
    };

  fileSystems."/boot/ESP1" =
    {
      device = "/dev/disk/by-label/esp1";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
