{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/hardware.nix
    ../common/network.nix
    ../common/users.nix
    ../common/general.nix
  ];

  networking.hostName = "ij-laptop";
  networking.hostId = "d4c95480";

  services.openvpn.servers.office-vpn = {
    config = "config /home/ij/.config/vpn/ij-mobile.ovpn";
    autoStart = false;
    updateResolvConf = true;
  };
}
