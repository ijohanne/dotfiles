#!/usr/bin/env bash

EFI_DEVICE=$(blkid -o device -t PARTLABEL="EFI System Partition")
EFI_UUID=$(lsblk -d -o uuid -n $EFI_DEVICE)
BOOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux Boot")
BOOT_UUID=$(lsblk -d -o uuid -n $BOOT_DEVICE)
ROOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux ZFS")
ROOT_UUID=$(lsblk -d -o uuid -n $ROOT_DEVICE)

cata <<EOF
  fileSystems."/" = {
    device = "zroot/root";
    fsType = "zfs";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/$EFI_UUID";
    fsType = "vfat";
  };

  fileSystems."/boot" = {
    device = "/dev/mapper/decrypted-boot";
    fsType = "ext4";
  };

  boot.initrd.luks.devices.decrypted-boot = {
    device = "/dev/disk/by-uuid/${BOOT_UUID}";
  };

  boot.initrd.luks.devices.decrypted-root = {
    device = "/dev/disk/by-uuid/${ROOT_UUID}";
  };

  swapDevices = [ ];

EOF

