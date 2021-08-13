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
    enable = true;
    nginx = {
      serverName = "analytics.unixpimps.net";
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

  systemd.services.matomo-setdbpass = {
    description = "MySQL database password setup (matomo)";
    wants = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.mariadb}/bin/mysql -uroot -e "GRANT ALL PRIVILEGES ON ${statsConfig.db}.* TO ${statsConfig.user}@localhost IDENTIFIED BY '${statsConfig.password}';"
      '';
      User = "root";
      PermissionsStartOnly = true;
      RemainAfterExit = true;
    };
  };
}
