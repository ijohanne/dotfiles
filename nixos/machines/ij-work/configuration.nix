{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common/hardware.nix
      ../common/network.nix
      ../common/users.nix
      ../common/general.nix
    ];

  networking.hostName = "ij-work";
  networking.hostId = "81727bb7";

  boot.initrd.luks.devices.decrypted-disk-name = {
    device = "/dev/disk/by-uuid/6e06a844-d428-4e2f-b3c1-91a7581cdb08";
  };
}
