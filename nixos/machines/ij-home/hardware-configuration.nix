{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  hardware.cpu.amd.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  fileSystems."/" = {
    device = "zroot/root";
    fsType = "zfs";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/2AAE-EF34";
    fsType = "vfat";
  };

  boot.initrd.luks.devices.decrypted-disk-name = {
    device = "/dev/disk/by-uuid/32db0649-dd5a-44a9-b4ad-a69fe2383ce4";
    keyFile = "/keyfile.bin";
  };

  boot.loader = {
    grub = {
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root 441E-43E7
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 32;
}
