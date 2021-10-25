{ pkgs, config, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "nvme" "usb_storage" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "tcp_bbr" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_5_14;
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
  boot.initrd.mdadmConf = config.environment.etc."mdadm.conf".text;

  environment.etc."mdadm.conf".text = ''
    HOMEHOST delirium
    MAILADDR sysops@unixpimps.net
  '';

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

  fileSystems."/var/borgbackup" =
    {
      device = "ftpback-rbx2-146.ovh.net:/export/ftpbackup/ns3199796.ip-141-94-130.eu";
      fsType = "nfs";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

}
