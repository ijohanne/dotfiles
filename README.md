This repository contains my NixOS and home-manager configs, configuration for Neovim, sway, et all, and documentation on how to use the setup provided here.

# Table of contents
- [NixOS installation](#nixos-installation)
  * [Prerequisite information](#prerequisite-information)
  * [Start wifi (optional)](#start-wifi--optional-)
  * [Setup needed software](#setup-needed-software)
  * [Set local variables](#set-local-variables)
  * [Setup partitions](#setup-partitions)
  * [Format the EFI partition](#format-the-efi-partition)
  * [Setup encryption](#setup-encryption)
  * [Enable ZFS on encrypted storage](#enable-zfs-on-encrypted-storage)
  * [Mount the target filesystems](#mount-the-target-filesystems)
  * [Enable extra LUKS key for only needing one password when booting](#enable-extra-luks-key-for-only-needing-one-password-when-booting)
  * [Generate NixOS config](#generate-nixos-config)
  * [Replace ZFS/LUKS bootloader elements](#replace-zfs-luks-bootloader-elements)
  * [Set `hostId`](#set--hostid-)
  * [Set `hostName`](#set--hostname-)
  * [Setup user home directory](#setup-user-home-directory)
  * [Clone the git repository](#clone-the-git-repository)
  * [Link configs](#link-configs)
  * [Adapt configs as needed](#adapt-configs-as-needed)
  * [Post-install setup](#post-install-setup)
  * [Reboot](#reboot)
  * [First boot](#first-boot)
  * [First user login](#first-user-login)
- [Maintenance](#maintenance)
- [Installation (live-cd fixups)](#installation-live-cd-fixups)
  * [Import a ZFS pool when booted on the live CD](#import-a-zfs-pool-when-booted-on-the-live-cd)
- [Setting up a Raspberry Pi](#setting-up-a-raspberry-pi)
  * [Building the image and writing it to a SD card](#building-the-image-and-writing-it-to-a-sd-card)
  * [Installation on the device](#installation-on-the-device)
  * [Local user setup](#local-user-setup)
- [Remote builders](#remote-builders)

## Prerequisite information
The block device used in this guide is exclusively catered to the USB flash
devices being `/dev/sda` and the new disk for NixOS to be installed on to be
`/dev/sdb`. However this needs to be updated to reflect the local installation
(such as the main device to install NixOS on is a NVMe disk, and as such the
block device to use would most likely be `/dev/nvme0n1` instead).

## Start wifi (optional)
You may need to adapt the interface to reflect the one on your device.
```bash
wpa_supplicant -B -i wlo1 -c <(wpa_passphrase 'SSID' 'PSK')
```

## Setup needed software
```bash
$> mkdir -p ~/.config/nixpkgs
$> echo '{ allowUnfree = true; }' > ~/.config/nixpkgs/config.nix
$> nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixos
$> nix-channel --update
$> nix-env -i git git-crypt
```

## Set local variables
Export the needed variables for this guide
```bash
$> export LOCAL_USER="ij" # Adapt as needed
$> export MACHINE_NAME="ij-laptop" # Adapt as needed
$> export DISK_DEVICE="/dev/sdb" # Adapt as needed
$> export BOOT_DEVICE="/dev/sdb1" # Adapt as needed
$> export MAIN_DEVICE="/dev/sdb2" # Adapt as needed
```

## Setup partitions
Setup 2 partitions
* efi (code - ef00, last sector - +200M)
* encrypted zfs (code: default, last sector - rest of disk)
```bash
$> gdisk $DISK_DEVICE
gdisk> o
gdisk> Y
gdisk> n
gdisk> <enter>
gdisk> <enter>
gdisk> +200M
gdisk> ef00
gdisk> n
gdisk> <enter>
gdisk> <enter>
gdisk> <enter>
gdisk> <enter>
gdisk> w
gdisk> Y
```

## Format the EFI partition
```bash
$> mkfs.vfat -n NIXOS_BOOT $BOOT_DEVICE
```

## Setup encryption
(if you change the `decrypted-disk-name` below, make sure to change it in the
rest of the guide when applicable)
```bash
$> cryptsetup luksFormat $MAIN_DEVICE --type luks1
$> cryptsetup luksOpen $MAIN_DEVICE decrypted-disk-name
```

## Enable ZFS on encrypted storage
(NOTE: Replace `deadbeef` with proper name found via `/dev/disk/by-id/`)
```bash
$> zpool create -o ashift=12 -O mountpoint=none zroot /dev/disk/by-id/dm-uuid-CRYPT-LUKS1-deadbeef-decrypted-disk-name
$> zfs create zroot/root -o mountpoint=legacy
```

## Mount the target filesystems
```bash
$> mount -t zfs zroot/root /mnt
$> mkdir /mnt/efi
$> mount $BOOT_DEVICE /mnt/efi
```

## Enable extra LUKS key for only needing one password when booting
```bash
$> dd if=/dev/urandom of=./keyfile.bin bs=1024 count=4
$> cryptsetup luksAddKey $MAIN_DEVICE ./keyfile.bin
$> mkdir /mnt/boot
$> mkdir -p /etc/secrets/initrd
$> cp keyfile.bin /etc/secrets/initrd/keyfile.bin
```

## Generate NixOS config
```bash
$> nixos-generate-config --root /mnt
```

## Replace ZFS/LUKS bootloader elements
(NOTE: Replace `deadbeef` with proper name found via `/dev/disk/by-id/`)


Replace the `boot.*` section(s) of `/mnt/etc/nixos/configuration.nix` with the following
```
  boot.initrd.luks.devices.decrypted-disk-name = {
    device = "/dev/disk/by-uuid/deadbeef";
    keyFile = "/keyfile.bin";
  };

  boot.initrd.secrets = {
    "/keyfile.bin" = "/etc/secrets/initrd/keyfile.bin";
  };


  boot.loader = {
    efi.efiSysMountPoint = "/efi";

    grub = {
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      zfsSupport = true;
      copyKernels = true;
    };

    grub.efiInstallAsRemovable = true;
    efi.canTouchEfiVariables = false;
  };
```

## Set `hostId`
ZFS needs the `hostId`, which is found by running `head -c 8 /etc/machine-id` and then inserted into `/mnt/etc/nixos/configuration.nix` under the property `networking.hostId`

## Set `hostName`
Add `networking.hostName` and set it to the name of the machine.

## Setup user home directory
```bash
$> mkdir -p /mnt/home/$LOCAL_USER/
```

## Clone the git repository
```bash
$> mkdir -p /mnt/home/$LOCAL_USER/.config
$> git clone --recursive https://github.com/ijohanne/dotfiles /mnt/home/$LOCAL_USER/.dotfiles
```

## Link configs
Copy the newly generated configs to git
```bash
$> mkdir -p /mnt/home/$LOCAL_USER/.dotfiles/nixos/machines/$MACHINE_NAME
$> mv /mnt/etc/nixos/configuration.nix /mnt/home/$LOCAL_USER/.dotfiles/nixos/machines/$MACHINE_NAME
$> mv /mnt/etc/nixos/hardware-configuration.nix /mnt/home/$LOCAL_USER/.dotfiles/nixos/machines/$MACHINE_NAME
$> printf "import /mnt/home/$LOCAL_USER/.dotfiles/nixos/machines/$MACHINE_NAME/configuration.nix" > /mnt/etc/nixos/configuration.nix
```

## Adapt configs as needed
Enable needed elements (see sample configs already in repo)
* Bluetooth
* Users

## Post-install setup
```bash
$> printf "import /home/$LOCAL_USER/.dotfiles/nixos/machines/$MACHINE_NAME/configuration.nix" > /mnt/etc/nixos/configuration.nix
```

## Reboot
```bash
$> reboot
```

## First boot
Login as root, set password for your added user, and swap to unstable as below (`nixos-unstable` is used instead of `nixpkgs-unstable` as we're using NixOS and want the full tests to pass).
```bash
$> sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
```

## First user login
Login as your new user and setup `home-manager`
```bash
$> MACHINE_NAME="ij-laptop" # Change machine name here
$> $HOME/.dotfiles/activate.sh $MACHINE_NAME
```

# Maintenance
Update the system
```bash
$> sudo nixos-rebuild switch --upgrade
$> sudo reboot
```

Update the local user repo
```bash
$> $HOME/.dotfiles/update-niv.sh
$> home-manager switch
$> ( cd $HOME/.dotfiles && git add . && git commit -m "Niv updates" && git push )
```
# Installation (live-cd fixups)
Pick the needed step
* Install NixOS `nixos-install`
* Rebuild configuration only `nixos-install --no-bootloader --no-root-passwd --no-channel-copy`
* Enter a chroot to perform post-setup steps (if needed) `nixos-enter`


## Import a ZFS pool when booted on the live CD
```bash
$> cryptsetup luksOpen $MAIN_DEVICE decrypted-disk-name
$> zpool import
$> # You may need to do the following for each
$> zpool import -f POOL_ID_FROM_ABOVE
$> mount -t zfs zroot/root /mnt
$> mount $BOOT_DEVICE /mnt/efi
```

# Setting up a Raspberry Pi 
## Building the image and writing it to a SD card
Copy and adapt the [sd-card-rpi4.nix](nixos/machines/sd-card-rpi4.nix) as needed (include your own SSH key)
```bash
$> nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage \
    -I nixos-config=nixos/machines/sd-card-rpi4.nix \
    --argstr system aarch64-linux
```
When the build completes it will print the location of the image file
```bash
/nix/store/zzi6jl5v9xh535g029yyq4jh1nr3j58a-nixos-sd-image-20.09pre239318.c59ea8b8a0e-aarch64-linux.img
```
Insert an SD card and write it to the proper device (change the device as needed)
```bash
$> sudo dd if=/nix/store/zzi6jl5v9xh535g029yyq4jh1nr3j58a-nixos-sd-image-20.09pre239318.c59ea8b8a0e-aarch64-linux.img \
  of=/dev/sde bs=64K status=progress
$> sudo eject /dev/sde
```
## Installation on the device
You can now put the SD card in your Raspberry Pi, and it will be configured with your SSH key for the `nixos` user. To complete the installation do the following (following the example from the NTP server)
```bash
$> export LOCAL_USER="ij"    # Update this as needed
$> export MACHINE_NAME="ntp" # Update this as needed
$> mkdir -p /home/$LOCAL_USER
$> git clone --recursive https://github.com/ijohanne/dotfiles /home/$LOCAL_USER/.dotfiles
$> printf "import /home/$LOCAL_USER/.dotfiles/nixos/machines/$MACHINE_NAME/configuration.nix" > /etc/nixos/configuration.nix
$> nixos-rebuild switch --upgrade
$> passwd $LOCAL_USER # Don't forget to set the password for your local user, as we're now using `nix-install`
$> reboot
```
## Local user setup
When the Raspberry Pi is booted login as your local user and complete the local setup
```bash
$> export LOCAL_USER="ij"    # Update this as needed
$> export MACHINE_NAME="ntp" # Update this as needed
$> sudo chown -R $LOCAL_USER:adm $HOME/.dotfiles
$> $HOME/.dotfiles/activate.sh $MACHINE_NAME
```
Logout and login again - and the local user setup will be activated.

# Remote builders
On certain platforms builds are really slow, e.g. Raspberry Pi, so it makes sense to use remote builders. 
Make sure to have the proper SSH public key set to a trusted user in [users.nix](nixos/machines/common/users.nix) on the builder machine, and also make sure to enable `boot.binfmt.emulatedSystems` for the needed platforms (see [ij-home configuration](nixos/machines/ij-home/hardware-configuration.nix) for details).

The key has to be in `~root/.ssh` and the following is needed as part of the `~root/.ssh/config`, but remember to replace the `HostName`, `Port` and `User` part.

```
Host builder
        HostName 10.255.101.17
        Port 22
        User ij
        IdentitiesOnly yes
        IdentityFile /root/.ssh/nix_remote
```

The remainder of the config can be seen in [ntp config](nixos/machines/ntp/configuration.nix).
