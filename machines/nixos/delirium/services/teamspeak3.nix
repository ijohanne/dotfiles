{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "teamspeak-server"
  ];

  services.teamspeak3 = {
    enable = true;
    queryIP = "127.0.0.1";
  };

  networking.firewall =
    {
      allowedUDPPorts = [
        9987
        9999
        9988
        30033
      ];
    };
}
