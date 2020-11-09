#!/usr/bin/env bash

EFI_DEVICE=$(blkid -o device -t PARTLABEL="EFI System Partition")
EFI_UUID=$(lsblk -d -o uuid -n $EFI_DEVICE)
ROOT_DEVICE=$(blkid -o device -t PARTLABEL="Linux ZFS")
ROOT_UUID=$(lsblk -d -o uuid -n $ROOT_DEVICE)
ROOT_ID=$(echo ${ROOT_UUID} | sed -e 's/\-//g')
ZPOOL="zroot"

cryptsetup luksOpen $ROOT_DEVICE decrypted-root
zpool import $ZPOOL
mount -t zfs zroot/root /mnt
mkdir /mnt/boot
mount $EFI_DEVICE /mnt/boot
