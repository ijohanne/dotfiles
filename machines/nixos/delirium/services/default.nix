{ secrets, config, pkgs, lib, ... }:
{
  imports = [
    ./gitea.nix
    (import ./prometheus.nix { inherit secrets config pkgs lib; })
    (import ./monitoring { inherit secrets config pkgs lib; })
    (import ./seafile.nix { inherit secrets config pkgs lib; })
    (import ./matrix.nix { inherit secrets config pkgs lib; })
    (import ./matomo.nix { inherit secrets config pkgs lib; })
    (import ./vsftpd.nix { inherit secrets config pkgs lib; })
    ./teamspeak3.nix
    (import ./geoip-updater.nix { inherit secrets config pkgs lib; })
    (import ./vaultwarden.nix { inherit secrets config pkgs lib; })
    (import ./mail.nix { inherit secrets config pkgs lib; })
    ./nginx.nix
    ./mariadb.nix
    ./pastebin.nix
    ./virtualhosts.nix
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
    passwordAuthentication = false;
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  services.xserver = { enable = false; };

  services.borgbackup.jobs.services = {
    paths = [ "/var/backup" "/var/dkim" "/var/sieve" ];
    encryption.mode = "none";
    repo = "/var/borgbackup/services";
    startAt = "*-*-* 04:00:00";
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 3;
    };
  };

  services.postgresqlBackup = {
    enable = true;
    startAt = "*-*-* 02:00:00";
    location = "/var/backup/postgresql";
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
