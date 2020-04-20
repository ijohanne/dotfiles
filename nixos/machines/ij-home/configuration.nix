{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/hardware.nix
    ../common/network.nix
    ../common/users.nix
    ../common/general.nix

  ];

  services.openvpn.servers.office-vpn = {
    config = "config /home/ij/.config/vpn/ij-mobile.ovpn";
    autoStart = false;
    updateResolvConf = true;
  };

  networking.hostName = "ij-home";
  networking.hostId = "f6f3a438";
  system.stateVersion = "19.09";

}
