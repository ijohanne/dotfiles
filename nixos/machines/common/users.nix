{ config, pkgs, ... }:

{
  users.users.ij = {
    isNormalUser = true;
    name = "ij";
    group = "adm";
    extraGroups = [
      "wheel"
      "disk"
      "audio"
      "video"
      "networkmanager"
      "systemd-journal"
      "docker"
      "dialout"
    ];
    createHome = true;
    uid = 1000;
    home = "/home/ij";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGL566DZXxjOA78LSP1zNYw3mazmpN8iyqQ4YEbGUSub ij@unixpimps.net"
    ];
  };

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.mutableUsers = true;

  nix.trustedUsers = [ "ij" ];
}
