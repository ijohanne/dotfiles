{ lib, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  fileSystems."/" = {
    device = "zroot/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A42C-E605";
    fsType = "vfat";
  };

  boot.initrd.luks.devices.decrypted-root = {
    device = "/dev/disk/by-uuid/cdbc8ad0-4cb8-4b79-a1a8-314ed0adcf66";
  };

  swapDevices = [ ];

}
