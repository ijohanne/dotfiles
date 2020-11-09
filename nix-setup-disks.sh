#!/usr/bin/env bash

DISK_DEVICE=$1

if [ -z "$DISK_DEVICE" ]; then
        echo "Usage: nix-setup-disks.sh [disk device e.g. /dev/nvme0n1, /dev/sda, etc]"
        exit 1
fi

#Partition disk
sgdisk -og $DISK_DEVICE
sgdisk -n 1:4096:1646590 -c 1:"EFI System Partition" -t 1:ef00 $DISK_DEVICE
ENDSECTOR=$(sgdisk -E $DISK_DEVICE)
sgdisk -n 2:1646591:$ENDSECTOR -c 2:"Linux ZFS" -t 2:8e00 $DISK_DEVICE
sgdisk -p $DISK_DEVICE

# Format EFI partition
export EFI_DEVICE=$(blkid -o device -t PARTLABEL="EFI System Partition")
EFI_UUID=$(lsblk -d -o uuid -n $EFI_DEVICE)
mkfs.vfat -n NIXOS_BOOT $EFI_DEVICE

# Format / partition
export ROOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux ZFS")
cryptsetup luksFormat $ROOT_DEVICE
cryptsetup luksOpen $ROOT_DEVICE decrypted-root
ROOT_UUID=$(lsblk -d -o uuid -n $ROOT_DEVICE)
ROOT_ID=$(echo ${ROOT_UUID} | sed -e 's/\-//g')
zpool create -o ashift=12 -O mountpoint=none zroot /dev/disk/by-id/dm-uuid-CRYPT-LUKS2-${ROOT_ID}-decrypted-root
zfs create zroot/root -o mountpoint=legacy

# Setup and mount paths
mount -t zfs zroot/root /mnt
mkdir /mnt/boot
mount $EFI_DEVICE /mnt/boot

