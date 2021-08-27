{ config, pkgs, lib, ... }:
let
  backupScript = pkgs.fetchFromGitHub {
    owner = "danielebailo";
    repo = "couchdb-dump";
    rev = "master";
    sha256 = "05zl8k7ixvwk5ib7x9qjryd38g2p4vhgw6n0pgf9p4kfznvxn6vw";
  };
  couchdbBackupScript = ''
    set -o pipefail
    mkdir -p /var/backup/opsplaza
    ${pkgs.bash}/bin/bash ${backupScript}/couchdb-dump.sh -b -H 127.0.0.1 -d themailer \
      -f /var/backup/opsplaza/themailer-couchdb.json
  '';
in
{
  services.nginx = {
    virtualHosts = {
      "themailer.opsplaza.com" = {
        serverAliases = [ "themailer.ragetech.dk" ];
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:12000";
          };
        };
      };
    };
  };
  virtualisation.oci-containers.containers.couchdb = {
    autoStart = true;
    image = "couchdb:2.3.1";
    ports = [ "127.0.0.1:5984:5984" ];
    volumes = [ "/var/opsplaza/couchdb:/opt/couchdb/data" ];
  };

  systemd.tmpfiles.rules = [
    "d /var/opsplaza/couchdb 0777 root root"
  ];

  systemd = {
    timers.opsplaza-couchdb-backup = {
      description = "Opsplaza couchdb backup timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "02:00:00";
        AccuracySec = "5m";
        Unit = "opsplaza-couchdb-backup.service";
      };
    };
    services.opsplaza-couchdb-backup = {
      description = "Opsplaza couchdb backup service";
      enable = true;
      script = couchdbBackupScript;
      path = with pkgs; [ gnused curl file gawk coreutils ];
    };
  };

}
