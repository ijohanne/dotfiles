{ config, lib, modulesPath, ... }:
let
  it87 = config.boot.kernelPackages.callPackage ./pkgs/it87.nix { };
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "it87" ];
  boot.kernelModules = [ "kvm-amd" "coretemp" ];
  boot.extraModulePackages = [ it87 ];
  boot.extraModprobeConfig = ''
    options it87 force_id=0x8628
  '';
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "acpi_enforce_resources=lax" ];

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
  services.thermald.enable = true;

  environment.etc."sysconfig/lm_sensors".text = ''
    HWMON_MODULES="coretemp"
  '';

  services.fwupd.enable = true;

  system.stateVersion = "21.05";
}
