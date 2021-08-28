{ config, pkgs, lib, ... }:
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    bind = "0.0.0.0";
  };

  services.mysqlBackup = {
    enable = true;
    calendar = "02:00:00";
    location = "/var/backup/mysql";
  };

  networking.firewall.interfaces.docker0 = {
    allowedTCPPorts = [ 3306 ];
    allowedUDPPorts = [ 3306 ];
  };
}
