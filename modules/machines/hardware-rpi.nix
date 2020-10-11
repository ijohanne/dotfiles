{ lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.loader.raspberryPi.firmwareConfig = ''
    dtoverlay=disable-bt
    dtoverlay=pi3-disable-bt
    dtoverlay=disable-wifi
    dtoverlay=pi3-disable-wifi
    dtoverlay=pps-gpio,gpiopin=4,capture_clear
    nohz=off
  '';

  hardware.deviceTree = {
    enable = true;
    overlays =
      [ "${pkgs.raspberrypifw}/share/raspberrypi/boot/overlays/pps-gpio.dtbo" ];

  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2178-694E";
    fsType = "vfat";
  };

  swapDevices = [ ];

  hardware.bluetooth.enable = false;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
