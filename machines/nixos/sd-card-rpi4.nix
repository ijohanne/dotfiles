{ lib, config, ... }: {
  imports =
    [ <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel.nix> ];
  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGL566DZXxjOA78LSP1zNYw3mazmpN8iyqQ4YEbGUSub ij@unixpimps.net"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeFunHfY3vS2izkp7fMHk2bXuaalNijYcctAF2NGc1T ij@unixpimps.net"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiCGBgFgwbHB+2m++ViEnhoFjww2Twvx8gXWcMvHvz3 martin@martin8412.dk"
  ];
  boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
  networking.wireless.enable = false;
  services.xserver = { enable = false; };
  sdImage.compressImage = false;
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
  services.openssh.enable = true;
}
