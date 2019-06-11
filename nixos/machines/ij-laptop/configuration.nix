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

  networking.hostName = "ij-laptop";
  networking.hostId = "d4c95480";

  boot.initrd.luks.devices.decrypted-disk-name = {
    device = "/dev/disk/by-uuid/55766568-7907-4916-9243-27d583aec775";
  };
}
