{ secrets, config, pkgs, lib, ... }:
let
  websiteConfig = {
    db = "perlpimpnet";
    user = "perlpimpnet";
    password = secrets.mariadb.perlpimpnet;
  };
in
{
  services.nginx = {
    virtualHosts = {
      "perlpimp.net" = {
        serverAliases = [ "www.perlpimp.net" "perlpimp.dk" "www.perlpimp.dk" ];
        http2 = true;
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:12000";
            extraConfig = ''
              if ($http_host != "perlpimp.net") {
                           rewrite ^ https://perlpimp.net$request_uri permanent;
                     }
            '';
          };
        };
      };
    };
  };
  virtualisation.oci-containers.containers.sniffy = {
    autoStart = true;
    image = "ghost:4-alpine";
    ports = [ "127.0.0.1:12000:2368" ];
    volumes = [ "/var/www/perlpimp.net/html:/var/lib/ghost/content" ];
    environment = {
      database__client = "mysql";
      database__connection__host = "172.17.0.1";
      database__connection__user = websiteConfig.user;
      database__connection__password = websiteConfig.password;
      database__connection__database = websiteConfig.db;
      url = "https://perlpimp.net";
    };
  };

  services.mysql = {
    ensureDatabases = [
      websiteConfig.db
    ];
    ensureUsers = [
      {
        name = "${websiteConfig.user}";
        ensurePermissions = {
          "${websiteConfig.db}.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.mysqlBackup.databases = [ websiteConfig.db ];

  services.borgbackup.jobs.services = {
    paths = [ "/var/www/perlpimp.net/html" ];
  };

  systemd.services.perlpimpnet-setdbpass = {
    description = "MySQL database password setup (perlpimpnet)";
    wants = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.mariadb}/bin/mysql -uroot -e "GRANT ALL PRIVILEGES ON ${websiteConfig.db}.* TO ${websiteConfig.user}@'%' IDENTIFIED BY '${websiteConfig.password}';"
      '';
      User = "root";
      PermissionsStartOnly = true;
      RemainAfterExit = true;
    };
  };
}
