{ secrets, config, pkgs, lib, ... }:
{
  imports = [
    ./services/gitea.nix
    (import ./services/prometheus.nix { inherit secrets config pkgs lib; })
    (import ./services/vsftpd.nix { inherit secrets config pkgs lib; })
    ./services/teamspeak3.nix
    (import ./services/geoip-updater.nix { inherit secrets config pkgs lib; })
    ./services/nginx.nix
    ./services/mariadb.nix
  ];

  services.openssh.permitRootLogin = "prohibit-password";
  services.xserver = { enable = false; };
  services.openssh.enable = true;

  services.borgbackup.jobs.services = {
    paths = [ "/var/backup" "/var/dkim" ];
    encryption.mode = "none";
    repo = "/var/borgbackup/services";
    startAt = "*-*-* 04:00:00";
  };

  services.postgresqlBackup = {
    enable = true;
    startAt = "02:00:00";
    location = "/var/backup/postgresql";
  };

  networking.firewall =
    {
      allowedTCPPorts = [
        22
      ];
    };
}
