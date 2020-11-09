#!/usr/bin/env bash

EFI_DEVICE=$(blkid -o device -t PARTLABEL="EFI System Partition")
EFI_UUID=$(lsblk -d -o uuid -n $EFI_DEVICE)
ROOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux ZFS")
ROOT_UUID=$(lsblk -d -o uuid -n $ROOT_DEVICE)
HOST_ID=$(head -c 8 /etc/machine-id)

cat <<EOF
  networking.hostId = "$HOST_ID";

  fileSystems."/" = {
    device = "zroot/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/$EFI_UUID";
    fsType = "vfat";
  };

  boot.initrd.luks.devices.decrypted-root = {
    device = "/dev/disk/by-uuid/$ROOT_UUID";
  };

  swapDevices = [ ];

EOF

