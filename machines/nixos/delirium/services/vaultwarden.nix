{ secrets, config, pkgs, lib, ... }:
let
  databaseConfig = {
    db = "vaultwarden";
    user = "vaultwarden";
    password = secrets.mariadb.vaultwarden;
  };
  privatePort = 8082;
  websocketPort = 3012;
  nixos_unstable = pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "6b574cd85176ecc96af1b93bf5d004c884863159";
    sha256 = "020xl42ynn22751y6g6djqagq1q9wrnk7m705l447z34rncvcb2w";
  };
in
{
  services.nginx = {
    virtualHosts = {
      "pass.unixpimps.net" = {
        http2 = true;
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString privatePort}";
            proxyWebsockets = true;
          };
          "/notifications/hub" = {
            proxyPass = "http://127.0.0.1:${toString websocketPort}";
            proxyWebsockets = true;
          };
          "/notifications/hub/negotiate" = {
            proxyPass = "http://127.0.0.1:${toString privatePort}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
  containers.vaultwarden = {
    privateNetwork = false;
    autoStart = true;
    ephemeral = false;
    nixpkgs = nixos_unstable;
    config = { config, pkgs, ... }: {
      services.vaultwarden = {
        enable = true;
        dbBackend = "mysql";
        config = {
          TZ = "Europe/Paris";
          WEB_VAULT_ENABLED = true;
          WEBSOCKET_ENABLED = true;
          WEBSOCKET_PORT = websocketPort;
          ROCKET_PORT = privatePort;
          SIGNUPS_ALLOWED = false;
          INVITATIONS_ALLOWED = true;
          INVITATION_ORG_NAME = "Unixpimps.net";
          DOMAIN = "https://pass.unixpimps.net";
          DATABASE_URL = "mysql://${databaseConfig.user}:${databaseConfig.password}@127.0.0.1:3306/${databaseConfig.db}";
          YUBICO_CLIENT_ID = secrets.vaultwarden.clientId;
          YUBICO_SECRET_KEY = secrets.vaultwarden.secretKey;
          ADMIN_TOKEN = secrets.vaultwarden.adminToken;
          SMTP_HOST = "delirium.unixpimps.net";
          SMTP_FROM = "no-reply@unixpimps.net";
          SMTP_FROM_NAME = "Vaultwarden";
          SMTP_USERNAME = secrets.vaultwarden.email.username;
          SMTP_PASSWORD = secrets.vaultwarden.email.password;
        };
      };
    };
  };

  services.mysql = {
    ensureDatabases = [
      databaseConfig.db
    ];
    ensureUsers = [
      {
        name = "${databaseConfig.user}";
        ensurePermissions = {
          "${databaseConfig.db}.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.mysqlBackup.databases = [ databaseConfig.db ];

  systemd.services.vaultwarden-setdbpass = {
    description = "MySQL database password setup (vaultwarden)";
    wants = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecPreStart = ''${pkgs.coreutils}/bin/sleep 10'';
      ExecStart = ''
        ${pkgs.mariadb}/bin/mysql -uroot -e "GRANT ALL PRIVILEGES ON ${databaseConfig.db}.* TO ${databaseConfig.user}@localhost IDENTIFIED BY '${databaseConfig.password}';"
      '';
      User = "root";
      PermissionsStartOnly = true;
      RemainAfterExit = true;
    };
  };
}
