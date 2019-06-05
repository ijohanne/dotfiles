# Setup needed software
```bash
$> mkdir -p ~/.config/nixpkgs
$> echo '{ allowUnfree = true; }' > ~/.config/nixpkgs/config.nix
$> nix-env -i git git-crypt
```

# Setup partitions
Setup 2 partitions
* efi (code - ef00, last sector - +200M)
* encrypted zfs (code: default, last sector - rest of disk)
```bash
$> gdisk /dev/sdb
```

# Format the EFI partition
```bash
$> mkfs.vfat -n NIXOS_BOOT /dev/sdb1
```

# Setup encryption
```bash
$> cryptsetup luksFormat /dev/sdb2
$> cryptsetup luksOpen /dev/sdb2 decrypted-disk-name
```

# Enable ZFS on encrypted storage
(NOTE: Replace `deadbeef` with proper name found via `/dev/disk/by-id/`)
```bash
$> zpool create -o ashift=12 -O mountpoint=none zroot /dev/disk/by-id/dm-uuid-CRYPT-LUKS1-deadbeef-decrypted-disk-name
$> zfs create zroot/root -o mountpoint=legacy
```

# Mount the target filesystems
```bash
$> mount -t zfs zroot/root /mnt
$> mkdir /mnt/efi
$> mount /dev/sdb1 /mnt/efi
```

# Enable extra LUKS key for only needing one password when booting
```bash
$> dd if=/dev/urandom of=./keyfile.bin bs=1024 count=4
$> cryptsetup luksAddKey /dev/sdb2 ./keyfile.bin
$> mkdir /mnt/boot
$> echo ./keyfile.bin | cpio -o -H newc -R +0:+0 --reproducible | gzip -9 > /mnt/boot/initrd.keys.gz`
```

# Generate NixOS config
```bash
$> nixos-generate-config --root /mnt
```

# Replace ZFS/LUKS bootloader elements
(NOTE: Replace `deadbeef` with proper name found via `/dev/disk/by-id/`)



Replace the `boot.*` section(s) of `/mnt/etc/nixos/configuration.nix` with the following
```
  boot.initrd.luks.devices.decrypted-disk-name = {
    device = "/dev/disk/by-uuid/deadbeef";
    keyFile = "/keyfile.bin";
  };

  boot.loader = {
    efi.efiSysMountPoint = "/efi";

    grub = {
      device = "nodev";
      efiSupport = true;
      extraInitrd = "/boot/initrd.keys.gz";
      enableCryptodisk = true;
      zfsSupport = true;
    };

    grub.efiInstallAsRemovable = true;
    efi.canTouchEfiVariables = false;
  };
```

# Set `hostId`
ZFS needs the `hostId`, which is found by running `head -c 8 /etc/machine-id` and then inserted into `/mnt/etc/nixos/configuration.nix` under the property `networking.hostId`

# Set `hostName`
Add `networking.hostName` and set it to the name of the machine.

# Setup user home directory
```bash
$> mkdir -p /mnt/home/$LOCAL_USER/
```

# Clone the git repository
```bash
$> mkdir -p /mnt/home/$LOCAL_USER/.config
$> git clone --recursive https://gitlab.com/ijohanne/dotfiles /mnt/home/$LOCAL_USER/.dotfiles
```

# Link configs
Copy the newly generated configs to git
```bash
$> mkdir -p /mnt/home/ij/.dotfiles/nixos/machines/$MACHINE_NAME
$> mv /mnt/etc/nixos/configuration.nix /mnt/home/$LOCAL_USER/.dotfiles/nixos/machines/$MACHINE_NAME
$> mv /mnt/etc/nixos/hardware-configuration.nix /mnt/home/$LOCAL_USER/.dotfiles/nixos/machines/$MACHINE_NAME
$> printf "import /mnt/home/$LOCAL_USER/.dotfiles/nixos/machines/$MACHINE_NAME/configuration.nix" > /mnt/etc/nixos/configuration.nix
```
