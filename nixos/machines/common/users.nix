{ config, pkgs, ... }:

{
  users.users.ij = {
    isNormalUser = true;
    name = "ij";
    group = "adm";
    extraGroups = [ "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal" ];
    createHome = true;
    uid = 1000;
    home = "/home/ij";
	};

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.mutableUsers = true;
}