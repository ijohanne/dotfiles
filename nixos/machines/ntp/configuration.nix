{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/users.nix
    ../common/general-rpi.nix

  ];

  networking.hostName = "ntp";
  system.stateVersion = "20.09";

  services.gpsd = {
    enable = true;
    device = "/dev/ttyS0 /dev/pps0";
  };

  services.ntp = {
    enable = true;
    extraConfig = ''
      server 127.127.28.0 minpoll 4 maxpoll 4
      fudge 127.127.28.0 time1 0.9999 refid GPS
      server 127.127.28.1 minpoll 4 maxpoll 4 prefer
      fudge 127.127.28.1 refid PPS
    '';
  };
}

