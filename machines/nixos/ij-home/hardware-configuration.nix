{ lib, ... }:

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

  fileSystems."/" = {
    device = "/dev/disk/by-id/dm-uuid-CRYPT-LUKS2-25d8fc4627b84f9dbedaabd13c2657ca-decrypted-root";
    fsType = "btrfs";
    options = [ "subvol=nixos" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1291-5F61";
    fsType = "vfat";
  };

  boot.initrd.luks.devices.decrypted-root = {
    device = "/dev/disk/by-uuid/25d8fc46-27b8-4f9d-beda-abd13c2657ca";
  };

  swapDevices = [ ];
  nix.maxJobs = lib.mkDefault 32;
}
