#!/usr/bin/env bash

DISK_DEVICE=$1

#Partition disk
sgdisk -og $DISK_DEVICE
sgdisk -n 1:2048:4095 -c 1:"BIOS Boot Partition" -t 1:ef02 $DISK_DEVICE
sgdisk -n 2:4096:413695 -c 2:"EFI System Partition" -t 2:ef00 $DISK_DEVICE
sgdisk -n 3:413696:1646590 -c 3:"Linux Boot" -t 3:8300 $DISK_DEVICE
ENDSECTOR=$(sgdisk -E $DISK_DEVICE)
sgdisk -n 4:1646591:$ENDSECTOR -c 4:"Linux ZFS" -t 4:8e00 $DISK_DEVICE
sgdisk -p $DISK_DEVICE

# Format EFI partition
export EFI_DEVICE=$(blkid -o device -t PARTLABEL="EFI System Partition")
EFI_UUID=$(lsblk -d -o uuid -n $EFI_DEVICE)
mkfs.vfat -n NIXOS_BOOT $EFI_DEVICE

# Format /boot device
export BOOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux Boot")
BOOT_UUID=$(lsblk -d -o uuid -n $BOOT_DEVICE)
cryptsetup luksFormat $BOOT_DEVICE --type luks1
cryptsetup luksOpen $BOOT_DEVICE decrypted-boot
mkfs.ext4 /dev/mapper/decrypted-boot

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
mount /dev/mapper/decrypted-boot /mnt/boot
mkdir /mnt/efi
mount $EFI_DEVICE /mnt/efi

