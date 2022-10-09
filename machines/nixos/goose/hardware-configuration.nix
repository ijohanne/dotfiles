{ lib, modulesPath, pkgs, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" "tcp_bbr" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "igb" ];

  fileSystems."/" =
    {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = [ "subvol=nixos" ];
    };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/397B-B9BF";
    fsType = "vfat";
  };

  swapDevices = [ ];

  hardware.video.hidpi.enable = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "conservative";
  services.thermald.enable = true;

  services.fwupd.enable = true;

  system.stateVersion = "22.05";
}
