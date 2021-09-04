#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
        echo "Usage: nix-rescue-mount.sh [fstype zfs|btrfs]"
        exit 1
fi

DISK_FS=$1

if [ "$DISK_FS" != "zfs" ] && [ "$DISK_FS" != "btrfs" ]; then
        echo "fstype must be either zfs or btrfs"
        exit 1
fi

EFI_DEVICE=$(blkid -o device -t PARTLABEL="EFI System Partition")
ROOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux ZFS")
ROOT_UUID=$(lsblk -d -o uuid -n "$ROOT_DEVICE")
ROOT_ID=${ROOT_UUID//-/}
ZPOOL="zroot"
ROOT_DECRYPTED_DEVICE="/dev/disk/by-id/dm-uuid-CRYPT-LUKS2-${ROOT_ID}-decrypted-root"

cryptsetup luksOpen "$ROOT_DEVICE" decrypted-root

if [ "$DISK_FS" == "zfs" ]; then
  zpool import ${ZPOOL}
  mount -t zfs zroot/root /mnt
else
  mount -t btrfs -o subvol=nixos "$ROOT_DECRYPTED_DEVICE" /mnt
fi

mkdir /mnt/boot
mount "$EFI_DEVICE" /mnt/boot
