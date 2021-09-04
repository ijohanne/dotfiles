This repository contains my NixOS and home-manager configs, configuration for Neovim, sway, et al., and documentation on how to use the setup provided here.

# Table of contents
- [NixOS installation](#nixos-installation)
  * [Prerequisite information](#prerequisite-information)
  * [Start WiFi (optional)](#start-wifi-optional)
  * [Setup needed software](#setup-needed-software)
  * [Set local variables](#set-local-variables)
  * [Setup the disk](#setup-the-disk)
  * [Generate NixOS config](#generate-nixos-config)
  * [Set `hostName`](#set-hostname)
  * [Generate extra hardware settings](#generate-extra-hardware-settings)
  * [Setup user home directory](#setup-user-home-directory)
  * [Clone the git repository](#clone-the-git-repository)
  * [Link configs](#link-configs)
  * [Adapt configs as needed](#adapt-configs-as-needed)
  * [Execute install](#execute-install)
  * [Post-install setup](#post-install-setup)
  * [Reboot](#reboot)
  * [First user login](#first-user-login)
  * [Maintenance](#maintenance)
- [Installation (live-cd fixups)](#installation-live-cd-fixups)
  * [Mounting filesystems](#mounting-filesystems)
- [Setting up a Raspberry Pi](#setting-up-a-raspberry-pi)
  * [Building the image and writing it to a SD card](#building-the-image-and-writing-it-to-a-sd-card)
  * [Installation on the device](#installation-on-the-device)
  * [Local user setup](#local-user-setup)
- [Remote builders](#remote-builders)

## Prerequisite information
The block device used in this guide is exclusively catered to the USB flash
devices being `/dev/sda` and the new disk for NixOS to be installed on to be
`/dev/sdb`. However, this needs to be updated to reflect the local installation
(such as the main device to install NixOS on is a NVMe disk, and as such the
block device to use would most likely be `/dev/nvme0n1` instead).

## Start wifi (optional)
```bash
$> nmcli device wifi connect SSID-Name password wireless-password
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
$> export MACHINE_TYPE="nixos"
$> export MACHINE_NAME="ij-laptop" # Adapt as needed
$> export GITHUB_REPO="ijohanne/dotfiles" # Adapt if needed
$> export GITHUB_BRANCH="master" # Adapt if needed
$> export DISK_DEVICE="/dev/nvme0n1" # Adapt as needed
$> export DISK_FS="btrfs" # can be either btrfs or zfs
```

## Setup the disk
Run the following command to partition the disk using the same layout I use
```bash
$> curl https://raw.githubusercontent.com/$GITHUB_REPO/$GITHUB_BRANCH/nix-setup-disks.sh | bash -s $DISK_FS $DISK_DEVICE
```

## Generate NixOS config
```bash
$> nixos-generate-config --root /mnt
```

## Generate extra hardware settings
Run the below script, and insert the bits generated into your `hardware-configuration.nix`
```bash
$> curl https://raw.githubusercontent.com/$GITHUB_REPO/$GITHUB_BRANCH/nix-generate-extra-hardware.sh | bash -s $DISK_FS
```

## Setup user home directory
```bash
$> mkdir -p /mnt/home/$LOCAL_USER/
```

## Clone the git repository
```bash
$> mkdir -p /mnt/home/$LOCAL_USER/.config
$> git clone --recursive https://github.com/$GITHUB_REPO /mnt/home/$LOCAL_USER/.dotfiles
```

## Link configs
Copy the newly generated configs to git
```bash
$> mkdir -p /mnt/home/$LOCAL_USER/.dotfiles/machines/$MACHINE_TYPE/$MACHINE_NAME
$> mv /mnt/etc/nixos/configuration.nix /mnt/home/$LOCAL_USER/.dotfiles/machines/$MACHINE_TYPE/$MACHINE_NAME
$> mv /mnt/etc/nixos/hardware-configuration.nix /mnt/home/$LOCAL_USER/.dotfiles/machines/$MACHINE_TYPE/$MACHINE_NAME
$> printf "import /mnt/home/$LOCAL_USER/.dotfiles/machines/$MACHINE_TYPE/$MACHINE_NAME/configuration.nix" > /mnt/etc/nixos/configuration.nix
```

## Adapt configs as needed
Enable needed elements (see sample configs already in repo, and take special note on setting the right profile, and importing the right user settings if needed for it)
* Bluetooth
* Users

## Execute install
```bash
$> /mnt/home/$LOCAL_USER/.dotfiles/nixos-install.sh --root /mnt
```

## Post-install setup
```bash
$> printf "import /home/$LOCAL_USER/.dotfiles/machines/$MACHINE_TYPE/$MACHINE_NAME/configuration.nix" > /mnt/etc/nixos/configuration.nix
```

## Reboot
```bash
$> reboot
```

## First user login
Login as your new user and setup `home-manager`. Remember to adapt the relevant `home.nix` file so it includes the right user settings (see [this sample](machines/users/ij.nix)).
```bash
$> MACHINE_NAME="ij-laptop" # Change machine name here
$> MACHINE_TYPE="nixos"
$> $HOME/.dotfiles/activate.sh $MACHINE_TYPE $MACHINE_NAME
```

# Maintenance
Update the system
```bash
$> nixos-rebuild switch
$> sudo reboot
```

Update the local user repo
```bash
$> niv-home update
$> home-manager switch
$> ( cd $HOME/.dotfiles && git add . && git commit -m "Niv updates" && git push )
```
# Installation (live-cd fixups)
Pick the needed step
* Install NixOS `nixos-install`
* Rebuild configuration only `nixos-install --no-bootloader --no-root-passwd --no-channel-copy`
* Enter a chroot to perform post-setup steps (if needed) `nixos-enter`


## Mounting filesystems
```bash
$> export GITHUB_REPO="ijohanne/dotfiles" # Adapt if needed
$> export GITHUB_BRANCH="master" # Adapt if needed
$> export DISK_FS="btrfs" # can be either btrfs or zfs
$> curl https://raw.githubusercontent.com/$GITHUB_REPO/$GITHUB_BRANCH/nix-rescue-mount.sh | bash -s $DISK_FS
```

# Setting up a Raspberry Pi 
## Building the image and writing it to a SD card
Copy and adapt the [sd-card-rpi4.nix](machines/nixos/sd-card-rpi4.nix) as needed (include your own SSH key)
```bash
$> nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage \
    -I nixos-config=machines/nixos/sd-card-rpi4.nix \
    --argstr system aarch64-linux
```
When the build completes it will print the build path of the image file
```bash 
/nix/store/pw43175n3w0bxz2hnv3h4wfsgc20a1pf-nixos-sd-image-21.03pre-git-aarch64-linux.img
```
To get the path of the image run
```bash
$> ls/nix/store/pw43175n3w0bxz2hnv3h4wfsgc20a1pf-nixos-sd-image-21.03pre-git-aarch64-linux.img/sd-image/*img
nixos-sd-image-21.03pre-git-aarch64-linux.img
```
Insert an SD card and write the image to the proper device (update the environment variables)
```bash
$> DEVICE="/dev/mmcblk0"
$> IMG_PATH="/nix/store/pw43175n3w0bxz2hnv3h4wfsgc20a1pf-nixos-sd-image-21.03pre-git-aarch64-linux.img"
$> IMG_FILE="$IMG_PATH/nixos-sd-image-21.03pre-git-aarch64-linux.img"
$> sudo dd if=$IMG_FILE of=$DEVICE bs=64K status=progress
$> sudo sync $DEVICE
$> sudo eject $DEVICE
```
## Installation on the device
You can now put the SD card in your Raspberry Pi, and it will be configured with your SSH key for the `nixos` user. To complete the installation do the following (following the example from the NTP server)
```bash
$> export LOCAL_USER="ij"    # Update this as needed
$> export MACHINE_NAME="ntp" # Update this as needed
$> export MACHINE_TYPE="nixos"
$> mkdir -p /home/$LOCAL_USER
$> git clone --recursive https://github.com/ijohanne/dotfiles /home/$LOCAL_USER/.dotfiles
$> printf "import /home/$LOCAL_USER/.dotfiles/machines/$MACHINE_TYPE/$MACHINE_NAME/configuration.nix" > /etc/nixos/configuration.nix
$> $HOME/.dotfiles/nixos-rebuild.sh switch
$> passwd $LOCAL_USER # Don't forget to set the password for your local user, as we're not using `nix-install`
$> reboot
```
## Local user setup
When the Raspberry Pi is booted login as your local user and complete the local setup
```bash
$> export LOCAL_USER="ij"    # Update this as needed
$> export MACHINE_NAME="ntp" # Update this as needed
$> export MACHINE_TYPE="nixos"
$> sudo chown -R $LOCAL_USER:adm $HOME/.dotfiles
$> $HOME/.dotfiles/activate.sh $MACHINE_TYPE $MACHINE_NAME
```
Logout and login again - and the local user setup will be activated.

# Remote builders
On certain platforms builds are really slow, e.g. Raspberry Pi, so it makes sense to use remote builders. 
Make sure to have the proper SSH public key set to a trusted user in [users.nix](machines/common/users.nix) on the builder machine, and also make sure to enable `boot.binfmt.emulatedSystems` for the needed platforms (see [ij-home configuration](machines/ij-home/hardware-configuration.nix) for details).

The key has to be in `~root/.ssh` and the following is needed as part of the `~root/.ssh/config`, but remember to replace the `HostName`, `Port` and `User` part.

```
Host builder
        HostName 10.255.101.17
        Port 22
        User ij
        IdentitiesOnly yes
        IdentityFile /root/.ssh/nix_remote
```

The remainder of the config can be seen in [ntp config](machines/ntp/configuration.nix).
