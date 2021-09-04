#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
        echo "Usage: nix-generate-extra-hardware.sh [fstype zfs|btrfs]"
        exit 1
fi

DISK_FS=$1

if [ "$DISK_FS" != "zfs" ] && [ "$DISK_FS" != "btrfs" ]; then
        echo "fstype must be either zfs or btrfs"
        exit 1
fi

EFI_DEVICE=$(blkid -o device -t PARTLABEL="EFI System Partition")
EFI_UUID=$(lsblk -d -o uuid -n "$EFI_DEVICE")

if [ "$DISK_FS" == "zfs" ]; then
  ROOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux ZFS")
  ROOT_UUID=$(lsblk -d -o uuid -n "$ROOT_DEVICE")
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

  dotfiles.machines.zfsEnable = true;

EOF

else
  ROOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux BTRFS")
  ROOT_UUID=$(lsblk -d -o uuid -n "$ROOT_DEVICE")
  ROOT_ID=${ROOT_UUID//-/}
  HOST_ID=$(head -c 8 /etc/machine-id)
  ROOT_DECRYPTED_DEVICE="/dev/disk/by-id/dm-uuid-CRYPT-LUKS2-$ROOT_ID-decrypted-root"
  cat <<EOF
  networking.hostId = "$HOST_ID";

  fileSystems."/" = {
    device = "$ROOT_DECRYPTED_DEVICE";
    fsType = "btrfs";
    options = [ "subvol=nixos" ];
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

fi
