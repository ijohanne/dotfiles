{ config, pkgs, lib, ... }:

{
  services.openssh.permitRootLogin = "prohibit-password";
  services.xserver = { enable = false; };
  services.openssh.enable = true;
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
  };
  networking.firewall =
    {
      allowedTCPPorts = [
        # Web ports
        80
        443
        # SSH
        22
      ];
      allowedUDPPorts = [
      ];
    };
}
