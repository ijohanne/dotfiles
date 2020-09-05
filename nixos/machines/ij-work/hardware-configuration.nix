{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  hardware.cpu.intel.updateMicrocode = true;
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "zroot/root";
    fsType = "zfs";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/EBA8-7D73";
    fsType = "vfat";
  };

  boot.initrd.luks.devices.decrypted-disk-name = {
    device = "/dev/disk/by-uuid/6e06a844-d428-4e2f-b3c1-91a7581cdb08";
    keyFile = "/keyfile.bin";
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

}
