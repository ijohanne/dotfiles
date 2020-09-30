{ lib, ... }: {
  imports =
    [ <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-raspberrypi4.nix> ];
  users.extraUsers.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGL566DZXxjOA78LSP1zNYw3mazmpN8iyqQ4YEbGUSub ij@unixpimps.net"
  ];
  networking.wireless.enable = false;
  services.xserver = { enable = false; };
  sdImage.compressImage = false;
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
  services.openssh.enable = true;
}
