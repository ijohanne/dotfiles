{ config, pkgs, lib, ... }:

{
  networking.hostName = "delirium";
  networking = {
    useDHCP = false;
    interfaces."eno1" = {
      ipv4.addresses = [
        {
          address = "141.94.130.22";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2001:41d0:306:116::1";
          prefixLength = 64;
        }
      ];
      ipv6.routes = [
        {
          address = "2001:41d0:306:1ff:ff:ff:ff:ff";
          prefixLength = 128;
          options = {
            dev = "eno1";
          };
        }
      ];
    };
    defaultGateway = "141.94.130.254";
    defaultGateway6 = "2001:41d0:306:1ff:ff:ff:ff:ff";
    nameservers = [ "8.8.8.8" ];
  };

  networking.nat.enable = true;
  networking.nat.externalInterface = "eno1";
}
