{ secrets, config, pkgs, lib, ... }:
let
  statsConfig = {
    db = "matomo";
    user = "matomo";
    password = secrets.mariadb.matomo;
  };
in
{
  services.matomo = {
    package = pkgs.matomo.overrideAttrs (old: {
      patches = old.patches ++ [ ./patches/matomo.patch ];
    });
    enable = true;
    nginx = {
      enableACME = true;
      serverName = "analytics.unixpimps.net";
      serverAliases = [
        "matomo.delirium.unixpimps.net"
      ];
    };
  };
  services.mysql = {
    ensureDatabases = [
      statsConfig.db
    ];
    ensureUsers = [
      {
        name = "${statsConfig.user}";
        ensurePermissions = {
          "${statsConfig.db}.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.mysqlBackup.databases = [ statsConfig.db ];

  systemd.services.matomo-setdbpass = {
    description = "MySQL database password setup (matomo)";
    wants = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecPreStart = ''${pkgs.coreutils}/bin/sleep 10'';
      ExecStart = ''
        ${pkgs.mariadb}/bin/mysql -uroot -e "GRANT ALL PRIVILEGES ON ${statsConfig.db}.* TO ${statsConfig.user}@localhost IDENTIFIED BY '${statsConfig.password}';"
      '';
      User = "root";
      PermissionsStartOnly = true;
      RemainAfterExit = true;
    };
  };
}
