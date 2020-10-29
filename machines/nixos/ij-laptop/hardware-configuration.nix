{ lib, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "zroot/root";
    fsType = "zfs";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/F359-CE78";
    fsType = "vfat";
  };

  boot.initrd.luks.devices.decrypted-disk-name = {
    device = "/dev/disk/by-uuid/e24d6f35-a23e-4f01-a026-30364b1d30c2";
    keyFile = "/keyfile.bin";
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "ondemand";
  };

}
