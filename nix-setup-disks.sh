#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
        echo "Usage: nix-setup-disks.sh [fstype zfs|btrfs] [disk device e.g. /dev/nvme0n1, /dev/sda, etc]"
        exit 1
fi

DISK_FS=$1
DISK_DEVICE=$2

if [ "$DISK_FS" != "zfs" ] && [ "$DISK_FS" != "btrfs" ]; then
        echo "fstype must be either zfs or btrfs"
        exit 1
fi


#Partition disk
sgdisk -og "$DISK_DEVICE"
sgdisk -n 1:4096:1646590 -c 1:"EFI System Partition" -t 1:ef00 "$DISK_DEVICE"
ENDSECTOR=$(sgdisk -E "$DISK_DEVICE")
if [[ "$DISK_FS" == "zfs" ]]; then
        sgdisk -n 2:1646591:"$ENDSECTOR" -c 2:"Linux ZFS" -t 2:8e00 "$DISK_DEVICE"
else
        sgdisk -n 2:1646591:"$ENDSECTOR" -c 2:"Linux BTRFS" -t 2:8e00 "$DISK_DEVICE"
fi
sgdisk -p "$DISK_DEVICE"

# Format EFI partition
EFI_DEVICE=$(blkid -o device -t PARTLABEL="EFI System Partition")
mkfs.vfat -n NIXOS_BOOT "$EFI_DEVICE"

# Format / partition
if [ "$DISK_FS" == "zfs" ]; then
        ROOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux ZFS")
else
        ROOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux BTRFS")
fi
cryptsetup luksFormat "$ROOT_DEVICE"
cryptsetup luksOpen "$ROOT_DEVICE" decrypted-root
ROOT_UUID=$(lsblk -d -o uuid -n "$ROOT_DEVICE")
ROOT_ID=${ROOT_UUID//-/}
ROOT_DECRYPTED_DEVICE="/dev/disk/by-id/dm-uuid-CRYPT-LUKS2-${ROOT_ID}-decrypted-root"

if [ "$DISK_FS" == "zfs" ]; then
        zpool create -o ashift=12 -O mountpoint=none zroot "$ROOT_DECRYPTED_DEVICE"
        zfs create zroot/root -o mountpoint=legacy
        mount -t zfs zroot/root /mnt
else
        mount -t btrfs "$ROOT_DECRYPTED_DEVICE" /mnt
        btrfs subvolume create /mnt/nixos
        umount /mnt
        mount -t btrfs -o subvol=nixos "$ROOT_DECRYPTED_DEVICE" /mnt
fi

# Setup and mount paths
mkdir /mnt/boot
mount "$EFI_DEVICE" /mnt/boot

